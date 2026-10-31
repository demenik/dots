// Tracks nh rebuilds and deploy-rs runs in every herdr pane and mirrors their state into a
// workspace token. Matching runs server-side via `pane.output_matched`, which
// fires only when a match newly appears in the watched window
package main

import (
	"bufio"
	"encoding/json"
	"flag"
	"net"
	"os"
	"os/exec"
	"regexp"
	"strings"
	"time"
)

const (
	source = "dots.rebuild-notify"
	// Matches already on screen when a subscription starts are stale
	armDelay = time.Second
)

// Phase lines are followed by a pause (eval, sudo, activation), so a small
// window catches them while letting the previous run's lines scroll out.
// The first rule starts a run; matches cover nh and deploy-rs output.
var rules = []rule{
	{"building", regexp.MustCompile(`^> Building (NixOS|Home-Manager|Darwin) configuration|\[deploy\] \[INFO\] (Running checks|Evaluating flake|Building profile) `), 3},
	{"copying", regexp.MustCompile(`\[deploy\] \[INFO\] Copying profile `), 3},
	{"activating", regexp.MustCompile(`^> Activating configuration|\[deploy\] \[INFO\] Activating profile `), 3},
	{"bootloader", regexp.MustCompile(`^> Adding configuration to bootloader`), 3},
	{"sudo", regexp.MustCompile(`^(\[sudo[^\]]*\] [Pp]assword[^:]*|\(sudo for [^)]*\) [Pp]assword): *\**$`), 1},
}

type rule struct {
	state string
	re    *regexp.Regexp
	lines int
}

var (
	herdr    = envOr("HERDR_BIN_PATH", "herdr")
	socket   = os.Getenv("HERDR_SOCKET_PATH")
	errorRe  = regexp.MustCompile(`^Error:|\[(deploy|activate)\] \[ERROR\]`)
	startRe  = rules[0].re
	priority = map[string]int{"done": 1, "building": 2, "copying": 2, "activating": 2, "bootloader": 2, "failed": 3, "sudo": 4}
)

type msg struct {
	event, tag string
	data       json.RawMessage
}

type match struct {
	PaneID      string `json:"pane_id"`
	MatchedLine string `json:"matched_line"`
	Read        struct {
		WorkspaceID string `json:"workspace_id"`
	} `json:"read"`
}

type pane struct {
	workspace, state string
	conn             net.Conn
}

func envOr(key, def string) string {
	if v := os.Getenv(key); v != "" {
		return v
	}
	return def
}

func cli(out any, args ...string) bool {
	stdout, err := exec.Command(herdr, args...).Output()
	if err != nil {
		return false
	}
	if out == nil {
		return true
	}
	var resp struct {
		Result json.RawMessage `json:"result"`
	}
	return json.Unmarshal(stdout, &resp) == nil && json.Unmarshal(resp.Result, out) == nil
}

// subscribe forwards events to ch until the connection closes, then sends a
// "closed" message tagged with tag
func subscribe(subs []map[string]any, tag string, ch chan<- msg) net.Conn {
	conn, err := net.Dial("unix", socket)
	if err != nil {
		return nil
	}
	req, _ := json.Marshal(map[string]any{
		"id": "sub", "method": "events.subscribe",
		"params": map[string]any{"subscriptions": subs},
	})
	if _, err := conn.Write(append(req, '\n')); err != nil {
		_ = conn.Close()
		return nil
	}

	go func() {
		scanner := bufio.NewScanner(conn)
		scanner.Buffer(nil, 1<<20)
		for scanner.Scan() {
			var m struct {
				Event string          `json:"event"`
				Data  json.RawMessage `json:"data"`
			}
			if json.Unmarshal(scanner.Bytes(), &m) == nil && m.Event != "" {
				ch <- msg{event: m.Event, data: m.Data}
			}
		}
		_ = scanner.Err()
		ch <- msg{event: "closed", tag: tag}
	}()
	return conn
}

type watcher struct {
	panes map[string]*pane
	armed map[string]time.Time
	ch    chan msg
}

func (w *watcher) watch(id string, delay time.Duration) net.Conn {
	subs := []map[string]any{}
	for _, r := range rules {
		subs = append(subs, map[string]any{
			"type": "pane.output_matched", "pane_id": id, "source": "recent",
			"lines": r.lines, "match": map[string]string{"type": "regex", "value": r.re.String()},
		})
	}
	w.armed[id] = time.Now().Add(delay)
	return subscribe(subs, id, w.ch)
}

func (w *watcher) sync(delay time.Duration) {
	var list struct {
		Panes []struct {
			PaneID      string `json:"pane_id"`
			WorkspaceID string `json:"workspace_id"`
		} `json:"panes"`
	}
	if !cli(&list, "pane", "list") {
		return
	}
	dirty := map[string]bool{}
	seen := map[string]bool{}
	for _, p := range list.Panes {
		seen[p.PaneID] = true
		cur, ok := w.panes[p.PaneID]
		if !ok {
			cur = &pane{workspace: p.WorkspaceID}
			w.panes[p.PaneID] = cur
		}
		if cur.workspace != p.WorkspaceID {
			dirty[cur.workspace], dirty[p.WorkspaceID] = true, true
			cur.workspace = p.WorkspaceID
		}
		if cur.conn == nil {
			cur.conn = w.watch(p.PaneID, delay)
		}
	}
	for id, p := range w.panes {
		if !seen[id] {
			if p.conn != nil {
				_ = p.conn.Close()
			}
			dirty[p.workspace] = true
			delete(w.panes, id)
			delete(w.armed, id)
		}
	}
	for ws := range dirty {
		w.render(ws)
	}
}

// render reports the most important pane state of a workspace as its token
func (w *watcher) render(ws string) {
	best := ""
	for _, p := range w.panes {
		if p.workspace == ws && priority[p.state] > priority[best] {
			best = p.state
		}
	}
	args := []string{"workspace", "report-metadata", ws, "--source", source}
	if best == "" {
		args = append(args, "--clear-token", "rebuild")
	} else {
		args = append(args, "--token", "rebuild="+best)
	}
	cli(nil, args...)
}

func (w *watcher) notify(ws, title, sound string) {
	var info struct {
		Workspace struct {
			Label string `json:"label"`
		} `json:"workspace"`
	}
	label := ws
	if cli(&info, "workspace", "get", ws) {
		label = info.Workspace.Label
	}
	go cli(nil, "notification", "show", title, "--body", label, "--sound", sound)
}

// failed checks the output since the last build start for nh's error report
func failed(id string) bool {
	text, err := exec.Command(herdr, "pane", "read", id, "--source", "recent-unwrapped", "--lines", "200").Output()
	if err != nil {
		return false
	}
	lines := strings.Split(string(text), "\n")
	for i := len(lines) - 1; i >= 0 && !startRe.MatchString(lines[i]); i-- {
		if errorRe.MatchString(lines[i]) {
			return true
		}
	}
	return false
}

func focused(id string) bool {
	var info struct {
		Pane struct {
			Focused bool `json:"focused"`
		} `json:"pane"`
	}
	return cli(&info, "pane", "get", id) && info.Pane.Focused
}

func (w *watcher) onMatch(m match) {
	p, ok := w.panes[m.PaneID]
	if !ok || time.Now().Before(w.armed[m.PaneID]) {
		return
	}
	p.workspace = m.Read.WorkspaceID
	running := p.state != "" && p.state != "done" && p.state != "failed"

	state := ""
	for _, r := range rules {
		if r.re.MatchString(m.MatchedLine) {
			state = r.state
			break
		}
	}

	switch {
	case state == "building":
		p.state = state
	case !running:
		return
	case state == "sudo":
		p.state = state
		w.notify(p.workspace, "Rebuild needs sudo", "request")
	case state == "prompt":
		if failed(m.PaneID) {
			p.state = "failed"
			w.notify(p.workspace, "Rebuild failed", "done")
		} else {
			p.state = "done"
			w.notify(p.workspace, "Rebuild finished", "done")
		}
		if focused(m.PaneID) {
			p.state = ""
		}
	default:
		p.state = state
	}
	w.render(p.workspace)
}

func (w *watcher) onFocus(id string) {
	if p, ok := w.panes[id]; ok && (p.state == "done" || p.state == "failed") {
		p.state = ""
		w.render(p.workspace)
	}
}

func main() {
	prompt := flag.String("prompt", `^\$ *$`, "regex matching an idle shell prompt line")
	flag.Parse()

	rules = append(rules, rule{"prompt", regexp.MustCompile(*prompt), 1})

	w := &watcher{
		panes: map[string]*pane{},
		armed: map[string]time.Time{},
		ch:    make(chan msg, 64),
	}

	lifecycle := []map[string]any{
		{"type": "pane.created"}, {"type": "pane.closed"}, {"type": "pane.moved"}, {"type": "pane.focused"},
	}
	if subscribe(lifecycle, "", w.ch) == nil {
		os.Exit(1)
	}
	w.sync(armDelay)

	for m := range w.ch {
		switch m.event {
		case "pane.output_matched":
			var data match
			if json.Unmarshal(m.data, &data) == nil {
				w.onMatch(data)
			}
		case "pane_focused":
			var data struct {
				PaneID string `json:"pane_id"`
			}
			if json.Unmarshal(m.data, &data) == nil {
				w.onFocus(data.PaneID)
			}
		case "pane_created":
			w.sync(0)
		case "pane_closed", "pane_moved":
			w.sync(armDelay)
		case "closed":
			if m.tag == "" {
				os.Exit(0)
			}
			if p, ok := w.panes[m.tag]; ok {
				p.conn = nil
				time.AfterFunc(armDelay, func() { w.ch <- msg{event: "resync"} })
			}
		case "resync":
			w.sync(armDelay)
		}
	}
}
