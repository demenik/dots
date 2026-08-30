import subprocess

GRAY = "\033[90m"
RESET = "\033[0m"

plain_lines = subprocess.run(
    ["git", "status", "-sb"], capture_output=True, text=True, check=True
).stdout.splitlines()
colored_lines = subprocess.run(
    ["git", "-c", "color.status=always", "status", "-sb"],
    capture_output=True,
    text=True,
    check=True,
).stdout.splitlines()

if not plain_lines:
    raise SystemExit

print(colored_lines[0])


class Node:
    def __init__(self) -> None:
        self.children: dict[str, "Node"] = {}
        self.prefix: str | None = None
        self.label: str | None = None


root = Node()

for plain_line, colored_line in zip(plain_lines[1:], colored_lines[1:]):
    if not plain_line:
        continue
    rest = plain_line[3:]
    prefix = colored_line[: len(colored_line) - len(rest)]

    if " -> " in rest:
        old, new = rest.split(" -> ")
        treepath = new
        label = f"{old.split('/')[-1]} -> {new.split('/')[-1]}"
    else:
        treepath = rest
        label = None

    node = root
    for part in treepath.split("/"):
        node = node.children.setdefault(part, Node())
    node.prefix = prefix
    node.label = label


def walk(node: Node, prefix: str = "") -> None:
    keys = sorted(node.children)
    for i, key in enumerate(keys):
        child = node.children[key]
        last = i == len(keys) - 1
        connector = f"{GRAY}└─ {RESET}" if last else f"{GRAY}├─ {RESET}"
        if child.children:
            print(f"{prefix}{connector}{key}/")
        else:
            print(f"{prefix}{connector}{child.prefix}{child.label or key}")
        walk(child, prefix + ("   " if last else f"{GRAY}│{RESET}  "))


walk(root)
