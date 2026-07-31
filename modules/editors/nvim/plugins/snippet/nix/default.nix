builtins.foldl' (x: y: x // y) {} (map import [
  ./flake
])
