{
  name = "ai";

  imports = [
    ./.mcp.nix
    ./.permissions.nix
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

      permissions = let
        commandRuleSetType = types.submodule {
          options = {
            allow = mkOption {
              type = types.listOf types.str;
              default = [];
              description = "Subcommands/args to allow for this command.";
            };
            ask = mkOption {
              type = types.listOf types.str;
              default = [];
              description = "Subcommands/args that require user confirmation for this command.";
            };
            deny = mkOption {
              type = types.listOf types.str;
              default = [];
              description = "Subcommands/args to deny for this command.";
            };
          };
        };

        permissionRuleSetType = types.submodule ({config, ...}: {
          options = {
            allow = mkOption {
              type = types.listOf types.str;
              default = [];
              description = "Patterns that are automatically allowed without confirmation, plus patterns generated from 'commands'.";
            };
            ask = mkOption {
              type = types.listOf types.str;
              default = [];
              description = "Patterns that require user confirmation before running, plus patterns generated from 'commands'.";
            };
            deny = mkOption {
              type = types.listOf types.str;
              default = [];
              description = "Patterns that are always denied, plus patterns generated from 'commands'.";
            };
            commands = mkOption {
              default = {};
              description = ''
                Shorthand for "<command> <subcommand> *" patterns. Define a command once
                (e.g. "bun") with the subcommands/args it applies to (e.g. ["install"]);
                each is expanded and merged into 'allow'/'ask'/'deny'.
              '';
              type = types.attrsOf commandRuleSetType;
            };
          };

          config = let
            expand = action:
              flatten (mapAttrsToList (
                  command: rules: map (subcommand: "${command} ${subcommand} *") rules.${action}
                )
                config.commands);
          in {
            allow = mkAfter (expand "allow");
            ask = mkAfter (expand "ask");
            deny = mkAfter (expand "deny");
          };
        });

        mkRuleSetOption = description:
          mkOption {
            inherit description;
            default = {};
            type = permissionRuleSetType;
          };
      in
        mkOption {
          description = "Permission rules for AI coding CLI tools, grouped by category. Each category accepts lists of patterns to allow, ask for confirmation, or deny. Wiring these into individual CLI configs is out of scope here.";
          default = {};
          type = types.submodule {
            options = {
              bash = mkRuleSetOption "Permission rules for shell/bash command execution.";
              read = mkRuleSetOption "Permission rules for reading files.";
              write = mkRuleSetOption "Permission rules for creating or overwriting files.";
              edit = mkRuleSetOption "Permission rules for editing existing files.";
              mcp = mkRuleSetOption "Permission rules for MCP server tool calls.";
              webFetch = mkRuleSetOption "Permission rules for fetching remote URLs.";
              webSearch = mkRuleSetOption "Permission rules for performing web searches.";
              other = mkOption {
                description = "Permission rules for arbitrary named tools or categories not covered above, keyed by tool/category name.";
                default = {};
                type = types.attrsOf permissionRuleSetType;
              };
            };
          };
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
