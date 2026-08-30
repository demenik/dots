{lib, ...}: {
  name = "multiplexer";

  moduleOptions = with lib; {
    multiplexer.autoAttach.backend = mkOption {
      type = types.nullOr (types.enum ["tmux" "herdr"]);
      default = null;
      description = ''
        Which multiplexer backend, if any, auto-starts/auto-attaches a "main"
        session on interactive shell start. Both backends can be imported at
        once, but only one may own shell startup.
      '';
    };
  };
}
