{
  pkgs,
  config,
  firefoxAddons,
  ...
}: let
  pname = "theme-vars";
  version = "1.0.0";
  addonId = "theme-vars@demenik";
  hostName = "theme_vars";
  prefix = "colorscheme";
  cssPath = "${config.xdg.cacheHome}/theme-vars/colors.css";

  host = pkgs.writers.writePython3Bin "theme-vars-host" {flakeIgnore = ["E203" "E501"];} (
    builtins.replaceStrings ["@cssPath@"] [cssPath] (builtins.readFile ./host.py)
  );
  hostExe = "${host}/bin/theme-vars-host";

  manifest = pkgs.writeText "manifest.json" (builtins.toJSON {
    manifest_version = 2;
    name = "Theme Variables";
    inherit version;
    description = "Exposes the system color scheme as CSS custom properties on every page";
    browser_specific_settings.gecko.id = addonId;
    background.scripts = ["background.js"];
    permissions = ["nativeMessaging" "webNavigation" "<all_urls>"];
  });

  xpi = pkgs.runCommand "${pname}-${version}.xpi" {nativeBuildInputs = [pkgs.zip];} ''
    cp ${manifest} manifest.json
    cp ${pkgs.replaceVars ./background.js {host = hostName;}} background.js
    zip -qX "$out" manifest.json background.js
  '';

  # buildFirefoxXpiAddon always fetches its src, so swap in the locally built xpi
  addon = (firefoxAddons.buildFirefoxXpiAddon {
    inherit pname version addonId;
    sha256 = "";
    meta = {};
  }).overrideAttrs {src = xpi;};
in {
  programs.librewolf.profiles.default = {
    extensions.packages = [addon];
    settings."xpinstall.signatures.required" = false;
  };

  theme.templates.theme-vars = {
    target = cssPath;
    text =
      # css
      ''
        :root {
        <* for name, value in colors *>
          --${prefix}-{{name | kebab_case}}: {{value.default.hex}};
          --${prefix}-{{name | kebab_case}}-rgb: {{value.default.rgb_csv}};
        <* endfor *>
        }
      '';
  };

  home.file.".librewolf/native-messaging-hosts/${hostName}.json".text = builtins.toJSON {
    name = hostName;
    description = "Pushes the generated color scheme to the theme-vars extension";
    path = hostExe;
    type = "stdio";
    allowed_extensions = [addonId];
  };
}
