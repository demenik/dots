# Codebase Guide for AI Agents Working on `dots`

This guide explains the repository layout, configuration framework, and guidelines for adding configurations or creating/modifying theme templates.

---

## 1. Project Overview & Architecture

This repository manages personal configurations for **NixOS** systems and **Home Manager** environments. It is built on top of [flake-modules](file:///home/demenik/dev/flake-modules), a schema-enforced framework that enables unified modules to define system-level options, user-level options, and secrets in a single cohesive file structure.

### Core Concepts:
- **Unified Modules**: Settings are defined in unified modules under [modules/](file:///home/demenik/dots/modules). A single module can include NixOS settings (`nixos` / `nixosConfig`), Home Manager settings (`home` / `homeConfig`), custom option definitions (`moduleOptions`), configuration overrides (`moduleConfig`), and overlays.
- **Discovery**: All non-hidden folders and files under [hosts/](file:///home/demenik/dots/hosts) and [users/](file:///home/demenik/dots/users) are automatically discovered and processed.
- **Schema-Based Enforcement**: Host and user properties are validated against strict Nix schemas defined in `flake-modules` to ensure type safety.
- **Dynamic Theming via Noctalia**: The system utilizes Noctalia Shell's template processing engine to automatically re-theme applications on-the-fly when the active color palette or wallpaper changes.

---

## 2. Directory Layout & Key Components

Below is the directory structure for this repository:

*   [flake.nix](file:///home/demenik/dots/flake.nix): Repository entrypoint. Declares inputs (such as `nixpkgs`, `home-manager`, `flake-modules`, `noctalia`, etc.) and calls `flake-modules.lib.mkNixosConfigurations` and `flake-modules.lib.mkHomeConfigurations`.
*   [hosts/](file:///home/demenik/dots/hosts): Contains machine-specific configurations.
    *   [hosts/default.nix](file:///home/demenik/dots/hosts/default.nix): Shared configuration modules imported by all hosts.
    *   [hosts/.full.nix](file:///home/demenik/dots/hosts/.full.nix): Shared configuration template for full desktop/laptop hosts. Being prefixed with a dot (`.`), it is hidden from automatic host discovery.
    *   [hosts/desktop/](file:///home/demenik/dots/hosts/desktop): Profile for the desktop machine.
    *   [hosts/thinkpad/](file:///home/demenik/dots/hosts/thinkpad): Profile for the Thinkpad P14s laptop.
    *   [hosts/zeus/](file:///home/demenik/dots/hosts/zeus): Profile for the Zeus machine.
    *   [hosts/homelab/](file:///home/demenik/dots/hosts/homelab): Profile for the homelab server.
*   [users/](file:///home/demenik/dots/users): User-specific environments.
    *   [users/demenik/](file:///home/demenik/dots/users/demenik): The primary user configuration (Dominik).
    *   [users/tct47/](file:///home/demenik/dots/users/tct47): Alternative user profile for zeus.
    *   [users/nix/](file:///home/demenik/dots/users/nix): Alternative user profile for homelab.
*   [modules/](file:///home/demenik/dots/modules): Unified modules organized by categorization:
    *   `ai/`: Configurations for AI clients (`opencode`, `gemini-cli`, `claude-code`, `antigravity-cli`).
    *   `browser/`: Web browsers (e.g., `librewolf`).
    *   `cli/`: Command-line interface utilities (`git`, `bat`, `btop`, `ripgrep`, etc.).
    *   `editors/`: Text editors and development IDEs (`nvim`, `godot`, `vscodium`, `android-studio`).
    *   `greeter/`: Display manager configurations (`greetd`).
    *   `programs/`: Desktop applications (`vesktop`, `spotify`, `obsidian`, `element`).
    *   `services/`: System and user services (`tor`, `i2p`, `vpn/`).
    *   `shell/`: Shell environments (`zsh`, `tmux`).
    *   `system/`: Low-level system utilities (`boot/`, `bluetooth`, `wine`).
    *   `terminal/`: Terminal emulators (`kitty`).
    *   `wm/`: Window managers (`hyprland`, `niri`) and shells (including Noctalia).

---

## 3. How to Extend the Codebase (Adding "Things")

### 3.1 Adding a New Host Configuration
To add a new machine named `myhost`:
1. Create a directory at `hosts/myhost/`.
2. Generate your hardware configuration on the target machine (via `nixos-generate-config --no-filesystems`) and save it as [hosts/myhost/hardware.nix](file:///home/demenik/dots/hosts/myhost/hardware.nix) (or copy it).
3. Create [hosts/myhost/default.nix](file:///home/demenik/dots/hosts/myhost/default.nix) containing:
   ```nix
   {
     imports = [
       ../.full.nix # Optional: import the common desktop config template
       ./hardware.nix
     ];

     system = "x86_64-linux"; # Target system architecture
     stateVersion = "25.11"; # Match target NixOS release
     hmStateVersion = "25.11";

     users = [ ../../users/demenik ]; # Link the active users

     modules = [
       ../default.nix
       ../../modules/system/boot/systemd-boot.nix
       # Add other modules needed for this specific machine
     ];

     moduleConfig = {
       # Configure module-specific options here
     };

     nixosConfig = {
       networking.hostName = "myhost";
       # Raw NixOS options go here
     };

     homeConfig = {
       # Home Manager options go here
     };
   }
   ```

### 3.2 Adding a New User Configuration
To add a new user profile named `myuser`:
1. Create a directory at `users/myuser/`.
2. Create [users/myuser/default.nix](file:///home/demenik/dots/users/myuser/default.nix) containing:
   ```nix
   {
     username = "myuser";

     modules = [
       ../../modules/shell/zsh
       ../../modules/terminal/kitty.nix
       # List of modules to load for this user
     ];

     moduleConfig = {
       # Configure user-level module options
     };

     nixosConfig = {
       # User creation boilerplate
       users.users.myuser = {
         description = "My User";
         extraGroups = [ "wheel" ];
       };
     };

     homeConfig = {
       # Raw Home Manager options
       programs.home-manager.enable = true;
     };
   }
   ```

### 3.3 Adding a New Module
Modules are placed in a subdirectory under [modules/](file:///home/demenik/dots/modules). They define and configure features transitively.

Here is the template for a unified module [modules/category/mytool.nix](file:///home/demenik/dots/modules/category/mytool.nix):
```nix
{lib, ...}: {
  name = "mytool"; # String identifier of the module

  modules = [
    # Declares transitive dependencies on other modules (paths relative to this file)
  ];

  moduleOptions = with lib; {
    # Define custom options that can be configured in moduleConfig
    mytool = {
      enable = mkEnableOption "Enable mytool";
      setting = mkOption {
        type = types.str;
        default = "default_value";
      };
    };
  };

  # System-level (NixOS) configuration
  nixos = { inputs, pkgs, lib, config, ... }: lib.mkIf config.mytool.enable {
    environment.systemPackages = [ pkgs.mytool ];
  };

  # User-level (Home Manager) configuration
  home = { inputs, pkgs, lib, config, ... }: lib.mkIf config.mytool.enable {
    home.file.".config/mytool/config.txt".text = ''
      setting = ${config.mytool.setting}
    '';
  };
}
```

### 3.4 Managing Secrets (sops-nix)
Secrets are declared at the module level and populated/mapped at the host or user level.

1. **In the module**:
   Declare that the module requires a secret:
   ```nix
   # inside modules/services/my-service.nix
   {
     name = "my-service";

     secrets = {
       myservice-token = {
         # Scope can be "nixos" (system wide decrypt), "hm" (user wide decrypt), or "both"
         scope = "hm";
       };
     };
   }
   ```
2. **In the host or user profile**:
   Provide the path to the SOPS-encrypted file:
   ```nix
   # inside users/demenik/default.nix
   secrets = {
     myservice-token.path = ./secrets/myservice.sops.yaml;
   };
   ```
3. **SOPS Keys**:
   Files are encrypted using age keys specified in [.sops.yaml](file:///home/demenik/dots/.sops.yaml).

### 3.5 Interchangeable Backend Modules (e.g. Multiplexers)

Some modules are meant to be swapped rather than composed -- `modules/shell/.multiplexer/tmux` and
`modules/shell/.multiplexer/herdr` are two interchangeable terminal-multiplexer/agent-runtime
backends. This shape (a small shared interface plus sibling backend implementations) is worth
following whenever a new feature has more than one viable backend and you don't want consumer code
hardcoding a dependency on a specific one.

- **"Enabled" is decided by import, not by a flag.** A user profile enables a backend by adding
  `modules/shell/.multiplexer/tmux` (or `.../herdr`) to its `modules` list -- there is no
  `multiplexer.backends.*.active`-style option to keep in sync with the import list. Consumer code
  should never existence-check the module's own custom options to detect "is it imported" (see next
  point for why); this is the pattern to actually copy, not to hardcode a new list of "known
  backends" every time one is added.
- **Check presence via `config.programs.<name>.enable`, not `options.programs ? <name>`.** For a
  backend wrapping a *stock* home-manager option namespace (like `programs.tmux`), an
  `options.programs ? tmux` existence check is always true whether or not this repo's tmux module is
  imported -- home-manager declares `programs.tmux` unconditionally, just defaulted to
  `enable = false`. The correct check is `config.programs.tmux.enable`. This does not apply to
  option namespaces that only exist because a whole separate module was imported (e.g.
  `options.programs ? nixvim` in `modules/shell/.multiplexer/tmux/plugins/vim-tmux-nav.nix` is valid,
  because nixvim is a flake-provided module genuinely absent unless imported) -- know which kind of
  namespace you're checking before picking a pattern.
- **A shared interface file lives directly under the parent hidden folder**
  (`modules/shell/.multiplexer/interface.nix`), imported by every sibling backend's own
  `home.imports`, holding only the cross-cutting bits that genuinely can't be decided by "which
  module is imported" alone -- e.g. `multiplexer.autoAttach.backend`, needed because multiple
  backends can be imported at once but only one should own interactive-shell auto-start. Don't grow
  this file into a second "which backend is active" flag; if presence-by-import can answer the
  question, use that instead.
- **Don't build feature parity you don't need.** tmux's custom status-icon plugin
  (`modules/shell/.multiplexer/tmux/plugins/status-icons.nix`, consumed by
  `modules/ai/claude-code/tmux-status.nix` and `modules/cli/sudo-rs.nix`) is tmux-only by design --
  herdr has built-in native agent status tracking and does not need it. Those two consumers check
  `config.programs.tmux.enable` specifically (not a generic "any multiplexer") on purpose. Don't
  "complete the abstraction" by building a herdr equivalent of `status-icons.nix` unless a real,
  separately-scoped feature request asks for it.

### 3.6 Adding Overlays (Cookbook)

Overlays add or override packages. Modules, hosts and users can all declare them via the
`overlays` option, which takes three lists of standard `final: prev: { ... }` functions:

| List | Applied to |
|------|------------|
| `overlays.nixos` | The NixOS package set only |
| `overlays.home` | The Home Manager package set only (also NixOS when the host uses `useGlobalPkgs`) |
| `overlays.both` | Both package sets |

Use `final.` for fetchers and dependencies, and `prev.<pkg>` when overriding the package itself.

#### 3.6.1 The Auto-Update Rule (MANDATORY)

**Every overlay you create must be auto-updatable** by the flake-modules updater app exposed in
[flake.nix](file:///home/demenik/dots/flake.nix):

```bash
nix run .#overlay-update                       # update every overlay package
nix run .#overlay-update -- <attr.path>        # update one package, e.g. ankiAddons.ankidiscord
nix run .#overlay-update -- --dry-run [<attr>] # only check, do not modify files
```

If you cannot make an overlay auto-updatable (see 3.6.6 for typical causes), you **must tell the
user so explicitly** in your response, explain **why** it is not possible, and say what they will
have to bump manually. Also add a short `# Not auto-updatable: <reason>` comment above the
overlay attribute. Never silently add an overlay with hard-coded versions or hashes that the
updater does not pick up.

After adding an overlay, always run `nix run .#overlay-update -- --dry-run <attr.path>` and check
that the package is listed as `Up to date` (not `Not supported`, `Check failed` or missing).

#### 3.6.2 How the Updater Works

Understanding this avoids most mistakes (source: `~/dev/flake-modules/lib/updater/`):

1. Every overlay of every host, user and module is evaluated against nixpkgs. Only attributes
   whose **definition lives inside this repository** and that **differ from `prev`** are
   considered. Plain attribute sets (e.g. `ankiAddons = prev.ankiAddons // { ... }`) are recursed
   into, giving dotted names like `ankiAddons.ankidiscord`.
2. For each derivation it looks for update info in this order:
   - `passthru.fmUpdate` exists -> **dynamic update** (3.6.4).
   - `src` is a derivation -> inspect `src` instead (this is how `overrideAttrs` with a new `src`
     works).
   - The derivation itself has `rev` and `hash`/`sha256` -> **static git update** (3.6.3).
3. The new values are written back **textually**: starting at the line of the overlay attribute
   name, the next 50 lines are scanned and the **first** occurrence of the old rev/version and the
   old hash are replaced. Consequently the old version and hash strings must appear literally
   within those 50 lines, and the version literal must not appear anywhere before the place it is
   defined (e.g. in a comment).

#### 3.6.3 Recipe: Git Sources (Tracks Default Branch HEAD)

Any fetcher with a `rev` and a `hash` (`fetchFromGitHub`, `fetchFromGitLab`, `fetchgit`, ...)
is supported out of the box. The updater runs `git ls-remote <repo> HEAD` and prefetches the new
commit. `fetchSubmodules`, `leaveDotGit`, `deepClone` and `sparseCheckout` are respected.

```nix
overlays.home = [
  (final: prev: {
    # A bare source used as data (see modules/cli/bat.nix)
    bat-theme-catppuccin = final.fetchFromGitHub {
      owner = "catppuccin";
      repo = "bat";
      rev = "6810349b28055dce54076712fc05fc68da4b8ec0";
      hash = "sha256-lJapSgRVENTrbmpVyn+UQabC9fpV1G1e+CdlJ090uvg=";
    };

    # Overriding the source of an existing nixpkgs package
    some-tool = prev.some-tool.overrideAttrs {
      src = final.fetchFromGitHub {
        owner = "someone";
        repo = "some-tool";
        rev = "0123456789abcdef0123456789abcdef01234567";
        hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
      };
    };
  })
];
```

Notes:
- Use a **full commit SHA** as `rev`. The updater always writes the HEAD commit SHA, so a tag
  like `v1.2.0` would be replaced by a commit on the default branch. If you need to follow
  **releases/tags** instead of HEAD, use the dynamic recipe below.
- `version` is not touched by this recipe. That is fine for data sources and unstable builds.

#### 3.6.4 Recipe: Custom Version Script (Release Tarballs, Binaries, ...)

When the source is a versioned URL (GitHub release assets, vendor download servers, ...), add
`passthru.fmUpdate` with the current version and a shell script that prints the latest version.

Requirements:
- `fmUpdate.version` is the current version string, exactly as it appears in the source URL.
- `fmUpdate.script` is a bash snippet that prints the new version as the **first
  whitespace-separated token on stdout**. Empty output or a non-zero exit results in
  `Check failed`.
- The script runs inside a **bubblewrap sandbox** with network access but only `/nix/store`,
  `/etc/static`, `/etc/resolv.conf` and `/etc/ssl/certs` mounted (`/home` and `/tmp` are empty).
  Reference **every tool by its store path** (`${lib.getExe final.curl}`,
  `${lib.getExe final.jq}`, `${lib.getExe final.gnugrep}`, ...); do not rely on `PATH`.
- `src` must be a URL fetcher (`fetchurl` or `fetchzip`) whose `url` **contains the version
  literally**. The new URL is computed by replacing the old version string with the new one, then
  prefetched (unpacked automatically for `fetchzip`).
- Write the version literal **once** (in `version = "..."`) and reference it everywhere else
  (`${version}` with `rec`, `finalAttrs.version`, or `inherit version`), so the textual
  replacement updates all usages.

Example with `finalAttrs` (see [modules/programs/zotero.nix](file:///home/demenik/dots/modules/programs/zotero.nix)):

```nix
overlays.home = [
  (final: prev: {
    mytool-bin = final.stdenv.mkDerivation (finalAttrs: {
      pname = "mytool-bin";
      version = "1.2.3";

      passthru.fmUpdate = {
        inherit (finalAttrs) version;
        script = "${final.lib.getExe final.curl} -s https://api.github.com/repos/owner/mytool/releases/latest | ${final.lib.getExe final.jq} -r '.tag_name | ltrimstr(\"v\")'";
      };

      src = final.fetchurl {
        url = "https://github.com/owner/mytool/releases/download/v${finalAttrs.version}/mytool-${finalAttrs.version}-linux-x86_64.tar.gz";
        hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
      };

      # ... build/install phases
    });
  })
];
```

Further references in this repository:
- [modules/lang/kotlin.nix](file:///home/demenik/dots/modules/lang/kotlin.nix): `final.callPackage`
  with `mkDerivation rec`, version scraped from the GitHub releases API (`.name`).
- [modules/programs/zotero.nix](file:///home/demenik/dots/modules/programs/zotero.nix): version
  extracted from the redirect target of a "latest" download link
  (`curl -sIL -o /dev/null -w '%{url_effective}' ... | grep -oP ...`).
- [modules/ai/antigravity-cli.nix](file:///home/demenik/dots/modules/ai/antigravity-cli.nix):
  `overrideAttrs` of an existing package, merging into `old.passthru`. The URL needs a different
  version format than the package, so `fmUpdate.version` holds the URL form and `version` is
  derived from it.

Useful script patterns:
- GitHub releases: `curl -s https://api.github.com/repos/<owner>/<repo>/releases/latest | jq -r '.tag_name | ltrimstr("v")'`
- Redirecting "latest" links: `curl -sIL -o /dev/null -w '%{url_effective}' <url> | grep -oP '<prefix>\K[^/]+'`
- Install scripts / JSON manifests published by the vendor: scrape them with `grep -oP` or `jq`.

Remember Nix string escaping inside `script`: `\"` for double quotes, `\\` for backslashes (e.g.
`\\K` in `grep -oP`), and `''${` instead of `${` when using `''` strings.

#### 3.6.5 Alternative: Flake Inputs

If upstream ships a flake that exposes the package, prefer adding it as an input in
[flake.nix](file:///home/demenik/dots/flake.nix) and using `inputs.<name>.packages.${system}.<pkg>`
in the overlay. Flake inputs are updated via `nix flake update` and count as auto-updatable.

#### 3.6.6 When Auto-Updating Is Not Possible

Typical cases the updater cannot handle (each requires telling the user, see 3.6.1):
- **Secondary dependency hashes** such as `cargoHash`, `vendorHash`, `npmDepsHash` or
  `pnpmDeps.hash`. Only the `src` hash is updated; these go stale after every source bump.
- **Several sources per package** (e.g. per-platform URLs or extra `fetchurl` calls). Only the
  first `src` and the first occurrence of its version/hash are handled.
- **No machine-readable latest version** (no API, no redirect, no manifest), or downloads that
  require authentication or cookies.
- **Pinned on purpose**, e.g. a specific commit or version required for compatibility.

Before giving up, check whether a different approach works (a flake input, a release-based
`fmUpdate` script instead of a git rev, or simply using the nixpkgs version without an overlay).

---

## 4. Theme Templates with Noctalia

The system supports dynamic theming using **Noctalia**. This allows application themes to update automatically in real-time when the wallpaper or active color scheme changes.

The theming schema is defined in [modules/wm/.shells/.templates.nix](file:///home/demenik/dots/modules/wm/.shells/.templates.nix).

### 4.1 Registering a Theme Template

To apply theme colors to an application, register it in the `theme.templates` option of your module:

```nix
theme.templates.myapp = {
  target = "~/.config/myapp/theme.css"; # Output path relative to user's home
  post_hook = "pkill -USR1 myapp || true"; # Optional reload command

  # Define the template inline:
  text =
    # css
    ''
      .my-app {
        background: {{colors.surface.default.hex}};
        color: {{colors.on_surface.default.hex}};
        accent: {{colors.primary.default.hex}};
        border: 1px solid {{colors.outline.default.hex}};
      }
    '';

  # OR reference a template file (mutually exclusive with text):
  # source = ./templates/myapp.css;
};
```

---

### 4.2 Template Syntax & Variables

Templates use the syntax `{{colors.name.mode.format}}` to inject dynamic values:

- **`name`**: The MD3 color name (e.g., `primary`, `surface`, `on_surface`)
- **`mode`**: `default` (follows the current active system mode), `dark`, or `light`.
- **`format`**: Output color format.

#### Output Formats

| Format | Example Output | Description |
|--------|----------------|-------------|
| `hex` | `#FF5733` | Standard hex representation |
| `hex_stripped` | `FF5733` | Hex representation without the leading `#` |
| `rgb` | `rgb(255, 87, 51)` | CSS rgb syntax |
| `rgb_csv` | `255,87,51` | Raw comma-separated RGB values |
| `rgba` | `rgba(255, 87, 51, 1.0)` | CSS rgba syntax |
| `hsl` | `hsl(14, 100%, 60%)` | HSL syntax |
| `hsla` | `hsla(14, 100%, 60%, 1.0)` | HSLA syntax |
| `red`, `green`, `blue` | `255`, `87`, `51` | Individual channel values (0-255) |
| `hue`, `saturation`, `lightness` | `14`, `100`, `60` | Individual HSL channel values |
| `alpha` | `1.0` | Alpha value (0.0-1.0) |

---

### 4.3 Available Colors

Noctalia generates a complete 48-color Material Design 3 palette:

#### Primary Colors
- **`primary`**: Main accent color
- **`on_primary`**: Text/icons displayed on primary backgrounds
- **`primary_container`**: Accent container background
- **`on_primary_container`**: Text/icons displayed on primary containers
- **`primary_fixed`**: Fixed primary (consistent across dark/light modes)
- **`primary_fixed_dim`**: Dimmed fixed primary
- **`on_primary_fixed`**: Text on fixed primary
- **`on_primary_fixed_variant`**: Variant text on fixed primary

#### Secondary Colors
- **`secondary`**: Secondary accent color
- **`on_secondary`**: Text/icons displayed on secondary backgrounds
- **`secondary_container`**: Secondary container background
- **`on_secondary_container`**: Text/icons displayed on secondary containers
- **`secondary_fixed`**: Fixed secondary
- **`secondary_fixed_dim`**: Dimmed fixed secondary
- **`on_secondary_fixed`**: Text on fixed secondary
- **`on_secondary_fixed_variant`**: Variant text on fixed secondary

#### Tertiary Colors
- **`tertiary`**: Tertiary accent color
- **`on_tertiary`**: Text/icons displayed on tertiary backgrounds
- **`tertiary_container`**: Tertiary container background
- **`on_tertiary_container`**: Text/icons displayed on tertiary containers
- **`tertiary_fixed`**: Fixed tertiary
- **`tertiary_fixed_dim`**: Dimmed fixed tertiary
- **`on_tertiary_fixed`**: Text on fixed tertiary
- **`on_tertiary_fixed_variant`**: Variant text on fixed tertiary

#### Error Colors
- **`error`**: Error/warning color
- **`on_error`**: Text/icons displayed on error backgrounds
- **`error_container`**: Container for error UI components
- **`on_error_container`**: Text/icons displayed on error containers

#### Surface Colors
- **`surface`**: Main background color
- **`on_surface`**: Primary text color
- **`surface_variant`**: Alternative/secondary surface background
- **`on_surface_variant`**: Secondary text color
- **`surface_dim`**: Dimmed surface background
- **`surface_bright`**: Bright surface background
- **`surface_container_lowest`**: Lowest elevation container
- **`surface_container_low`**: Low elevation container
- **`surface_container`**: Standard elevation container
- **`surface_container_high`**: High elevation container
- **`surface_container_highest`**: Highest elevation container

#### Outline & Utility Colors
- **`outline`**: Border/divider color
- **`outline_variant`**: Subtle/dimmed outline variant
- **`shadow`**: Shadow color
- **`scrim`**: Screen overlay/scrim color

#### Inverse Colors
- **`inverse_surface`**: Inverted background surface
- **`inverse_on_surface`**: Inverted text color
- **`inverse_primary`**: Inverted primary accent

#### Background Colors
- **`background`**: Main background (alias for `surface`)
- **`on_background`**: Main text color (alias for `on_surface`)

---

### 4.4 Filters

Modify colors using filters chained with the `|` symbol:

```ini
accent = {{colors.primary.default.hex | lighten 10}}
overlay = {{colors.surface.default.hex | set_alpha 0.8}}
muted = {{colors.error.default.hex | grayscale}}
```

You can chain multiple filters sequentially:

```ini
highlight = {{colors.primary.default.hex | lighten 10 | set_alpha 0.9}}
```

#### Color Filters

| Filter | Argument | Description |
|--------|----------|-------------|
| `grayscale` | none | Convert to grayscale |
| `invert` | none | Invert the color channels |
| `lighten` | percentage (0-100) | Increase lightness channel |
| `darken` | percentage (0-100) | Decrease lightness channel |
| `saturate` | percentage (0-100) | Increase saturation channel |
| `desaturate` | percentage (0-100) | Decrease saturation channel |
| `set_alpha` | float (0.0-1.0) | Set alpha/opacity value |
| `set_lightness` | percentage (0-100) | Set absolute lightness |
| `set_saturation` | percentage (0-100) | Set absolute saturation |
| `set_hue` | degrees (0-360) | Set absolute hue angle |
| `set_red` | value (0-255) | Set red channel value |
| `set_green` | value (0-255) | Set green channel value |
| `set_blue` | value (0-255) | Set blue channel value |
| `auto_lightness` | percentage | Lighten if the color is dark, darken if it is light |
| `blend` | `"#hex", amount` | Blend hue toward target color (amount: 0.0 - 1.0) |
| `harmonize` | `"#hex"` | M3 color harmonization (maximum 15° hue shift) |

#### String Filters

| Filter | Description |
|--------|-------------|
| `lower_case` | Convert to lowercase |
| `camel_case` | Convert to camelCase |
| `pascal_case` | Convert to PascalCase |
| `snake_case` | Convert to snake_case |
| `kebab_case` | Convert to kebab-case |
| `replace: "find", "replace"` | String replacement |

---

### 4.5 Advanced Features

#### Block Constructs

Control flow blocks are written using `<* ... *>` syntax.

##### For Loops
Iterate over colors, tonal palettes, or numeric ranges:
```css
<* for name, value in colors *>
  --color-{{name}}: {{value.default.hex}};
<* endfor *>
```
Available iterables:
- `colors` - All 48 color name/value pairs.
- `palettes.primary`, `palettes.secondary`, etc. - M3 tonal palettes.
- `0..10` - Numeric ranges.

Available loop variables inside the block:
- `loop.index` - Current iteration index (0-based).
- `loop.first` - `true` if first iteration.
- `loop.last` - `true` if last iteration.

##### Conditionals
```css
<* if {{ loop.first }} *>
  /* Initial item styles */
<* else *>
  /* Item styles */
<* endif *>
```

#### Custom Colors
Define custom accent sources in the Noctalia configuration to generate extra token sets (consisting of `{name}`, `on_{name}`, `{name}_container`, `on_{name}_container`, `{name}_source`, `{name}_value`):
```toml
[config.custom_colors]
warning = "#FFA500"
success = { color = "#00FF00", blend = true }
```

#### Special Tags
- **`{{image}}`**: Evaluates to the absolute path of the current source wallpaper image.

---

### 4.6 Examples

#### Neovim Color Scheme Lua Configuration
**Template declaration in module**:
```nix
theme.templates.nvim = {
  target = "~/.config/nvim/lua/colors/noctalia.lua";
  text = ''
    return {
      bg = "{{colors.surface.default.hex}}",
      fg = "{{colors.on_surface.default.hex}}",
      accent = "{{colors.primary.default.hex}}",
      error = "{{colors.error.default.hex}}",
      warning = "{{colors.tertiary.default.hex}}",
    }
  '';
};
```

#### CSS Variables Generation
**Template declaration in module**:
```nix
theme.templates.cssVars = {
  target = "~/.config/mytheme/variables.css";
  text = ''
    :root {
    <* for name, value in colors *>
      --{{name | kebab_case}}: {{value.default.hex}};
    <* endfor *>
    }
  '';
};
```

#### Icon Patching Script (GTK)
**Template declaration in module**:
```nix
theme.templates.patch-icons = {
  target = "~/.local/bin/patch-papirus-icons.sh";
  post_hook = "bash ~/.local/bin/patch-papirus-icons.sh";
  text = ''
    #!/usr/bin/env bash
    FOLDER_BASE='{{colors.primary.default.hex_stripped}}'
    FOLDER_DARK='{{colors.primary.default.hex | blend "#000000", 12 | replace "#", ""}}'
    FOLDER_DEEP='{{colors.primary.default.hex | blend "#000000", 65 | replace "#", ""}}'
    # Script logic using templated color values...
  '';
};
```

---

### 4.7 Troubleshooting

- **File Paths**: Ensure `target` or `source` uses absolute paths or `~` to refer to the home directory.
- **Syntax Validation**: Ensure template syntax is correct. Parentheses or invalid filter names will trigger generation errors.
- **Check Noctalia Logs**: If files do not appear or do not update, launch Noctalia from a terminal to view active trace logs.
- **Forced Updates**: Change settings (e.g., toggle dark mode, reload wallpaper) to trigger template rebuilds.

---

## 5. Development & Formatting Guidelines

To maintain consistency and readability across the configuration files in this repository, follow these formatting and style standards:

### 5.1 Formatting Tool
- **Alejandra**: All Nix files are formatted using `alejandra`.
  - **Devshell & Formatter**: The repository includes a default devshell containing `alejandra` and defines it as the default flake formatter. You can format files manually by running `nix fmt`.
  - **Pre-commit Hook**: A Git pre-commit hook is active. It automatically runs `nix fmt` (configured to run `alejandra -q` quietly) on all staged `.nix` files and re-stages them before the commit is finalized. Therefore, manually running the formatter prior to committing is no longer necessary.

### 5.2 Nix Function Argument Ordering
When defining functions, modules, or inline configuration blocks that accept Nix attributes (such as in system modules or user modules), consistently order parameters as follows:
1. `inputs` (if used)
2. `pkgs` (if used)
3. `lib` (if used)
4. `config` (if used)
Make sure to NEVER include arguments that are not used.

**Example (Unified Module Block Parameters):**
```nix
  # System-level (NixOS) configuration
  nixos = { inputs, pkgs, lib, config, ... }: lib.mkIf config.mytool.enable {
    # NixOS options
  };

  # User-level (Home Manager) configuration
  home = { inputs, pkgs, lib, config, ... }: lib.mkIf config.mytool.enable {
    # Home Manager options
  };
```

### 5.3 Single Quotes in Injected Code (`''` Strings)
Code embedded in Nix indented strings (`# lua`, `__raw`, `extraConfigLua`, ...) is highlighted and
linted via treesitter injections. The escape sequences Nix needs to write `''` inside such a string
(`'''`, `''\`) are excluded from the injected region, which breaks the injected parser (e.g. Lua
highlighting falls apart from the enclosing function onwards).

- **When the embedded code itself needs two consecutive single quotes** (e.g. a Lua string literal
  containing `''`), write each quote as the decimal escape `\39` instead of the Nix escape `'''`:
  ```nix
  # lua
  ''
    if s:sub(1, 2) == "\39\39" then
  ''
  ```
- Only use this when a Nix escape would otherwise be required. A single `'` needs no escape and
  stays as is; Nix escapes like `''$` in shell code are unaffected and must not be rewritten.
- `\39` only works in languages with decimal string escapes (Lua). For other languages, use their
  equivalent (e.g. `\x27`) only if it does not change what the code does.
