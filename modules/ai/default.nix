{
  name = "ai";

  imports = [
    ./.mcp.nix
    ./.skills
  ];

  home = {
    lib,
    config,
    ...
  }: {
    options.ai = with lib; {
      mcp = mkOption {
        description = "MCP Server configurations";
        default = {};
        type = types.attrsOf (types.submodule {
          options = {
            type = mkOption {
              type = types.enum ["local" "remote"];
              description = "Type of MCP server";
            };
            url = mkOption {
              type = types.nullOr types.str;
              default = null;
              description = "URL for remote MCP servers";
            };
            command = mkOption {
              type = types.nullOr (types.listOf types.str);
              default = null;
              description = "Command to run for local MCP servers, as a list of strings";
            };
            env = lib.mkOption {
              type = lib.types.attrsOf (lib.types.submodule {
                options = {
                  path = lib.mkOption {
                    type = lib.types.nullOr lib.types.str;
                    default = null;
                    description = "Path to the secret file (e.g. config.sops.secrets.<name>.path)";
                  };
                  text = lib.mkOption {
                    type = lib.types.nullOr lib.types.str;
                    default = null;
                    description = "Literal environment variable value";
                  };
                };
              });
              default = {};
              description = "Environment variables to pass to the MCP server";
            };
            headers = lib.mkOption {
              type = lib.types.attrsOf lib.types.str;
              default = {};
              description = "Headers to pass for remote MCP servers. Use $ENV_NAME to reference a variable defined in the env option.";
            };
          };
        });
      };

      skills = mkOption {
        description = "AI Skills configurations";
        default = {};
        type = types.attrsOf (types.submodule {
          options = {
            drv = mkOption {
              type = types.nullOr types.package;
              default = null;
              description = "Skill derivation";
            };
            text = mkOption {
              type = types.nullOr types.lines;
              default = null;
              description = "Skill content as text";
            };
            path = mkOption {
              type = types.nullOr types.path;
              default = null;
              description = "Skill content as a path to a directory or file";
            };
          };
        });
      };
    };

    config = {
      assertions =
        lib.flatten (
          lib.mapAttrsToList (name: server:
            [
              {
                assertion = server.type == "local" -> server.command != null && server.url == null;
                message = "AI MCP server '${name}' is local and must define 'command', but not 'url'.";
              }
              {
                assertion = server.type == "remote" -> server.url != null && server.command == null;
                message = "AI MCP server '${name}' is remote and must define 'url', but not 'command'.";
              }
            ]
            ++ lib.mapAttrsToList (envName: envVar: {
              assertion = !(envVar.path != null && envVar.text != null);
              message = "AI MCP server '${name}' env variable '${envName}' cannot define both 'path' and 'text'.";
            })
            server.env)
          config.ai.mcp
        )
        ++ lib.mapAttrsToList (name: skill: {
          assertion =
            (skill.drv != null && skill.text == null && skill.path == null)
            || (skill.drv == null && skill.text != null && skill.path == null)
            || (skill.drv == null && skill.text == null && skill.path != null);
          message = "AI skill '${name}' must define exactly one of 'drv', 'text', or 'path'.";
        })
        config.ai.skills;
    };
  };
}
