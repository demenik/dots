{
  name = "greetd-noctalia-greeter";
  modules = [./default.nix];

  nixos = {
    inputs,
    lib,
    config,
    ...
  }: let
    hmUser = lib.head (lib.attrValues config.home-manager.users);
    cursor = hmUser.home.pointerCursor;
    gtkFont = hmUser.gtk.font;

    transformToken = t:
      if t == null
      then null
      else let
        r = toString t.rotation;
      in
        if t.flipped
        then
          (
            if t.rotation == 0
            then "flipped"
            else "flipped-${r}"
          )
        else
          (
            if t.rotation == 0
            then "normal"
            else r
          );

    trimFloatString = s: let
      stripZeros = str:
        if lib.hasSuffix "0" str
        then stripZeros (lib.removeSuffix "0" str)
        else str;
    in
      lib.removeSuffix "." (
        if lib.hasInfix "." s
        then stripZeros s
        else s
      );

    mkOutputField = extract: let
      entries =
        lib.filter (e: e != null)
        (map (m: let
          v = extract m;
        in
          if v == null
          then null
          else "${m.output}:${v}")
        config.wm.monitors);
    in
      if entries == []
      then null
      else lib.concatStringsSep "; " entries;

    prune = x:
      if builtins.isAttrs x
      then let
        pruned = lib.filterAttrs (_: v: v != null) (lib.mapAttrs (_: prune) x);
      in
        if pruned == {}
        then null
        else pruned
      else x;

    settings = prune {
      session.default = config.greeter.sessionName;

      appearance =
        {
          scheme = "Synced";
          password_style = "random";
          hide_logo = true;
        }
        // lib.optionalAttrs (gtkFont.name != "") {
          font_family = gtkFont.name;
        };

      cursor = lib.optionalAttrs cursor.enable {
        theme = cursor.name;
        inherit (cursor) size;
      };

      keyboard = {
        layout = config.wm.input.keyboard.layout;
        variant = config.wm.input.keyboard.variant;
      };

      output = {
        layout = mkOutputField (
          m:
            if m.position == null
            then null
            else "${toString m.position.x},${toString m.position.y}"
        );
        transforms = mkOutputField (m: transformToken m.transform);
        scales = mkOutputField (
          m:
            if m.scale == null
            then null
            else trimFloatString (toString m.scale)
        );
      };
    };
  in {
    imports = [inputs.noctalia-greeter.nixosModules.default];

    environment.systemPackages = lib.optional cursor.enable cursor.package;

    programs.noctalia-greeter = {
      enable = true;
      inherit settings;
    };

    security.polkit.extraConfig =
      # js
      ''
        polkit.addRule(function (action, subject) {
          if (
            action.id == "org.noctalia.greeter.apply-appearance" &&
            subject.isInGroup("wheel")
          ) {
            return polkit.Result.YES;
          }
        });
      '';
  };

  home = {
    theme.templates.noctalia-greeter-sync = {
      target = "~/.local/state/noctalia-greeter-sync/sync.toml";
      post_hook =
        # bash
        ''
          sync_dir="$HOME/.local/state/noctalia-greeter-sync"
          wallpaper_src="{{image}}"

          for _ in $(seq 1 15); do
            [ -r "$wallpaper_src" ] && break
            sleep 1
          done

          if [ -r "$wallpaper_src" ]; then
            case "$wallpaper_src" in
            *.svg | *.SVG) ext="svg" ;;
            *) ext="png" ;;
            esac
            wallpaper_dst="$sync_dir/wallpaper.$ext"

            find "$sync_dir" -maxdepth 1 -name 'wallpaper.*' -not -name "wallpaper.$ext" -delete
            cp "$wallpaper_src" "$wallpaper_dst"
            sed -i "s#^path = \".*\"\$#path = \"/var/lib/noctalia-greeter/wallpaper.$ext\"#" "$sync_dir/sync.toml"
          else
            echo "noctalia-greeter-sync: wallpaper source unreadable, keeping last synced wallpaper" >&2
          fi

          pkexec noctalia-greeter-apply-appearance "$sync_dir"
        '';
      text =
        # toml
        ''
          # Kept here to fire post_hook on wallpaper-only change
          # source wallpaper: {{image}}

          [appearance.palette]
          primary = "{{colors.primary.default.hex}}"
          on_primary = "{{colors.on_primary.default.hex}}"
          secondary = "{{colors.secondary.default.hex}}"
          on_secondary = "{{colors.on_secondary.default.hex}}"
          tertiary = "{{colors.tertiary.default.hex}}"
          on_tertiary = "{{colors.on_tertiary.default.hex}}"
          error = "{{colors.error.default.hex}}"
          on_error = "{{colors.on_error.default.hex}}"
          surface = "{{colors.surface.default.hex}}"
          on_surface = "{{colors.on_surface.default.hex}}"
          surface_variant = "{{colors.surface_variant.default.hex}}"
          on_surface_variant = "{{colors.on_surface_variant.default.hex}}"
          outline = "{{colors.outline.default.hex}}"
          shadow = "{{colors.shadow.default.hex}}"
          hover = "{{colors.surface_container_high.default.hex}}"
          on_hover = "{{colors.on_surface.default.hex}}"

          [appearance.wallpaper]
          # Overwritten with the real extension by post_hook's sed once synced
          path = "/var/lib/noctalia-greeter/wallpaper.png"
          fill_mode = "crop"
        '';
    };
  };
}
