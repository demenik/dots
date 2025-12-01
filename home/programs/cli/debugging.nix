{pkgs, ...}: {
  home.packages = with pkgs; [
    vscode-extensions.vadimcn.vscode-lldb
  ];
}
