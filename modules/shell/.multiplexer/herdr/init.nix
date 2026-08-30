{
  lib,
  config,
  ...
}: {
  programs.zsh.initContent =
    lib.mkBefore
    # zsh
    ''
      ${
        lib.optionalString (config.multiplexer.autoAttach.backend == "herdr")
        # zsh
        ''
          if [ -n "$PS1" ] && [ -z "$HERDR_PANE_ID" ] && [ -z "$SSH_CONNECTION" ]; then
            exec herdr --session main
          fi
        ''
      }
    '';
}
