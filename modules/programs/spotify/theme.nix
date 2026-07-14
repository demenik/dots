{
  pkgs,
  inputs,
  lib,
  config,
  ...
}: let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};

  extensionJs =
    pkgs.writeTextDir "theme-hot-reload.js"
    # js
    ''
      (async function () {
        let lastVersion = null;

        async function loadNoctaliaTheme() {
          console.log("Reloading theme...");
          try {
            const res = await fetch(
              "http://127.0.0.1:8765/theme.css?t=" + new Date().getTime(),
              { cache: "no-store" },
            );
            const cssText = await res.text();
            const styleId = "noctalia-dynamic-style";
            let style = document.getElementById(styleId);
            if (!style) {
              style = document.createElement("style");
              style.id = styleId;
              document.head.appendChild(style);
            }
            style.innerHTML = cssText;
            console.log("Reloaded theme");
          } catch (err) {
            console.error("Failed to fetch theme css", err);
          }
        }

        while (true) {
          try {
            const res = await fetch(
              "http://127.0.0.1:8765/version?t=" + new Date().getTime(),
              { cache: "no-store" },
            );
            const version = await res.text();
            if (lastVersion === null || version !== lastVersion) {
              lastVersion = version;
              await loadNoctaliaTheme();
            }
          } catch (e) {
            // Server offline or not responding
          }
          await new Promise((r) => setTimeout(r, 2000));
        }
      })();
    '';

  serverPy =
    pkgs.writeScript "theme-server.py"
    # python
    ''
      import http.server
      import time


      class Handler(http.server.BaseHTTPRequestHandler):
          def log_message(self, format, *args):
              pass

          def do_OPTIONS(self):
              self.send_response(200)
              self.send_header("Access-Control-Allow-Origin", "*")
              self.send_header("Access-Control-Allow-Methods", "GET, POST, OPTIONS")
              self.end_headers()

          def do_GET(self):
              if self.path.startswith("/theme.css"):
                  self.send_response(200)
                  self.send_header("Access-Control-Allow-Origin", "*")
                  self.send_header("Content-Type", "text/css")
                  self.send_header("Cache-Control", "no-cache, no-store, must-revalidate")
                  self.end_headers()
                  try:
                      with open("/home/demenik/.config/spotify/noctalia.css", "rb") as f:
                          self.wfile.write(f.read())
                  except:
                      pass
                  return

              if self.path.startswith("/version"):
                  self.send_response(200)
                  self.send_header("Access-Control-Allow-Origin", "*")
                  self.send_header("Cache-Control", "no-cache, no-store, must-revalidate")
                  self.end_headers()
                  try:
                      self.wfile.write(str(self.server.update_version).encode())
                  except:
                      pass
                  return

          def do_POST(self):
              self.send_response(200)
              self.send_header("Access-Control-Allow-Origin", "*")
              self.end_headers()
              self.server.update_version += 1


      if __name__ == "__main__":
          server = http.server.ThreadingHTTPServer(("127.0.0.1", 8765), Handler)
          server.update_version = 0
          print("Spicetify Theme Hot-Reload Server running on 8765...")
          server.serve_forever()
    '';
in {
  theme.templates.spicetify = {
    enable = true;
    target = "~/.config/spotify/noctalia.css";
    text = ''
      :root, body, .Root {
        --spice-text: {{colors.on_surface.default.hex}} !important;
        --spice-subtext: {{colors.on_surface_variant.default.hex}} !important;
        --spice-main: {{colors.surface.default.hex}} !important;
        --spice-main-elevated: {{colors.surface_container.default.hex}} !important;
        --spice-main-transition: {{colors.surface_container_lowest.default.hex}} !important;
        --spice-highlight: {{colors.surface_container_high.default.hex}} !important;
        --spice-highlight-elevated: {{colors.surface_container_highest.default.hex}} !important;
        --spice-sidebar: {{colors.surface_container_lowest.default.hex}} !important;
        --spice-player: {{colors.surface_container.default.hex}} !important;
        --spice-card: {{colors.surface_container_low.default.hex}} !important;
        --spice-shadow: {{colors.surface_container_highest.default.hex}} !important;
        --spice-selected-row: {{colors.on_surface.default.hex}} !important;
        --spice-button: {{colors.primary.default.hex}} !important;
        --spice-button-active: {{colors.primary.default.hex}} !important;
        --spice-button-disabled: {{colors.primary.default.hex}} !important;
        --spice-tab-active: {{colors.surface.default.hex}} !important;
        --spice-notification: {{colors.tertiary.default.hex}} !important;
        --spice-notification-error: {{colors.error.default.hex}} !important;
        --spice-misc: {{colors.surface.default.hex}} !important;
        --spice-play-button: {{colors.secondary.default.hex}} !important;
        --spice-play-button-active: {{colors.secondary.default.hex}} !important;
        --spice-progress-fg: {{colors.primary.default.hex}} !important;
        --spice-progress-bg: {{colors.surface.default.hex}} !important;
        --spice-heart: {{colors.error.default.hex}} !important;
        --spice-pagelink-active: {{colors.on_tertiary_container.default.hex}} !important;
        --spice-radio-btn-active: {{colors.on_tertiary_container.default.hex}} !important;
      }
    '';
    post_hook = "${lib.getExe pkgs.curl} -X POST http://127.0.0.1:8765/ || true";
  };

  systemd.user.services.spicetify-theme-server = {
    Unit = {
      Description = "Spicetify Theme Hot-Reload Server";
      After = ["graphical-session.target"];
    };
    Service = {
      ExecStart = "${lib.getExe pkgs.python3} -u ${serverPy}";
      Restart = "on-failure";
    };
    Install = {
      WantedBy = ["default.target"];
    };
  };

  programs.spicetify = {
    theme = lib.mkIf (config.theme.type == "colorScheme") spicePkgs.themes.catppuccin;
    colorScheme = lib.mkIf (config.theme.type == "colorScheme") "mocha";

    enabledExtensions = [
      {
        src = extensionJs;
        name = "theme-hot-reload.js";
      }
    ];
  };
}
