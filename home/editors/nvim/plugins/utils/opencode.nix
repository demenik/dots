{pkgs, ...}: {
  home.packages = with pkgs; [lsof];

  programs.nixvim = {
    plugins.opencode = {
      enable = true;
    };

    plugins.which-key.settings.spec = [
      {
        __unkeyed-1 = "<leader>o";
        group = "Opencode";
        icon = {
          icon = "󱁉 ";
          color = "grey";
        };
      }
    ];
    keymaps = let
      opencode = key: action: desc: {
        key = "<leader>o${key}";
        action.__raw = ''function() require('opencode').${action} end'';
        options.desc = desc;
      };
    in [
      {
        key = "<M-#>";
        action.__raw = ''function() require('opencode').toggle() end'';
        options.desc = "Toggle opencode";
      }

      (opencode "o" "toggle()" "Toggle opencode")
      (opencode "a" "ask('@this: ', { submit = true })" "Ask opencode…")
      (opencode "x" "select()" "Execute opencode action…")

      {
        key = "<S-C-k>";
        action.__raw = ''function() require("opencode").command("session.half.page.up") end'';
        options.desc = "Scroll opencode up";
      }
      {
        key = "<S-C-j>";
        action.__raw = ''function() require("opencode").command("session.half.page.down") end'';
        options.desc = "Scroll opencode down";
      }
    ];

    plugins.snacks.settings = {
      input.enabled = true;
      picker = {
        enabled = true;
        actions.opencode_send.__raw = ''
          function(...)
            return require("opencode").snacks_picker_send(...)
          end
        '';
        win.input.keys."<a-a>" = {
          __unkeyed-1 = "opencode_send";
          mode = ["n" "i"];
        };
      };
      terminal.enabled = true;
    };
  };
}
