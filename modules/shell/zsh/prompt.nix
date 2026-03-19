{
  programs.oh-my-posh = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      version = 3;
      final_space = true;

      transient_prompt = {
        template = " ";
        foreground = "#f9e2af";
        background = "transparent";
      };

      blocks = [
        {
          type = "prompt";
          alignment = "left";
          newline = true;
          segments = [
            {
              template = "{{ .UserName }}@{{ .HostName }} ";
              foreground = "#cba6f7";
              type = "session";
              style = "plain";
            }
            {
              template = "{{ if ne .Type \"unknown\" }}󱄅 {{ end }}";
              foreground = "#89b4fa";
              type = "nix-shell";
              style = "plain";
              properties = {
                cache_duration = "none";
              };
            }
            {
              template = "in";
              foreground = "#585b70";
              type = "text";
              style = "plain";
            }
            {
              foreground = "#89dceb";
              type = "path";
              style = "powerline";
              properties = {
                cache_duration = "none";
                style = "full";
              };
            }
            {
              template = "{{if .UpstreamIcon}}{{ .UpstreamIcon }} {{end}}{{ .HEAD }}{{if .BranchStatus }} {{ .BranchStatus }}{{ end }}{{ if .Working.Changed }}  {{ .Working.String }}{{ end }}{{ if and (.Working.Changed) (.Staging.Changed) }} |{{ end }}{{ if .Staging.Changed }}  {{ .Staging.String }}{{ end }}{{ if gt .StashCount 0 }}  {{ .StashCount }}{{ end }}";
              foreground = "#585b70";
              type = "git";
              style = "plain";
              properties = {
                fetch_upstream_icon = true;
                fetch_status = true;
                upstream_icons = {
                  "gitea.demenik.dev" = "";
                };
              };
            }
          ];
        }

        {
          type = "prompt";
          alignment = "left";
          newline = true;
          segments = [
            {
              template = "";
              foreground = "#f9e2af";
              type = "text";
              style = "plain";
            }
          ];
        }
      ];
    };
  };
}
