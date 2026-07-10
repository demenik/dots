# demenik's dots

My NixOS dotfiles. This setup manages my NixOS systems and Home-Manager environments using a modular, declarative approach.

## flake-modules

The backbone of this repository is [**flake-modules**](https://github.com/demenik/flake-modules), a framework I developed to simplify the management of multi-host and multi-user Nix configurations. It allows bundling NixOS and Home-Manager Config into modules which can be imported by NixOS and non NixOS hosts.

### Package Overlay Updates
This repository utilizes the **Auto-Update Overlays** feature of `flake-modules` to keep fetcher-based packages (e.g. `fetchFromGitHub`, `fetchGit`) defined in overlays up-to-date. The tool automatically scans active overlays, fetches the latest commits from upstream, calculates the new hashes, and modifies the source configuration files in-place.

- **Check for updates (Dry Run):**
  ```bash
  nix run .#overlay-update -- --dry-run
  ```
- **Apply updates:**
  ```bash
  nix run .#overlay-update
  ```

For more details on setting up and extending this feature, see [flake-modules's USAGE.md - Updating Overlays](https://github.com/demenik/flake-modules/blob/main/USAGE.md#updating-overlays).

## Highlights

- **Flakes**: Fully reproducible configuration using Nix Flakes.
- **Wayland Setup**:
    - **Hyprland**: Fully configured tiling window manager.
    - **Noctalia Shell**: Desktop shell configured for my needs.
- **Nixvim (Neovim)**: Neovim configured using [Nixvim](https://github.com/nix-community/nixvim).
- **Security & Privacy**:
    - **Secure Boot**: Using [Lanzaboote](https://github.com/nix-community/lanzaboote).
    - **Secret Management**: I'm using `sops-nix` for secret management. See [flake-modules's USAGE.md](https://github.com/demenik/flake-modules/blob/main/USAGE.md) for more information about configuring `sops-nix` with `flake-modules`.
    - **Anonymity**: Modules for **Tor** and **I2P**. Can be used in a Librewolf Container.
    - **Librewolf**: Configuration with UserChrome tweaks. Extensions need manual set-up.
- **AI Integration**: Custom modules for AI CLI tools like `gemini-cli` and `opencode`.
- **Gaming & Media**: Modules for Steam, Mangohud, Spicetify (Spotify), and tools like Aseprite and Inkscape.
- **Hardware Optimized**: Configurations for my **Thinkpad P14s**  and my **Desktop** PC (fan control/audio).

## Repository Structure

```
├── hosts/              # Machine-specific configurations
├── modules/            # Reusable modules
│   ├── browser/        # Browser configurations
│   ├── cli/            # CLI utilities and AI tools
│   ├── editors/        # Editor configs including Neovim (Nixvim) and Godot
│   ├── programs/       # Desktop applications
│   ├── services/       # System services (Tor, VPN, Nextcloud, Pipewire)
│   ├── shell/          # Zsh, Tmux, and custom scripts
│   ├── system/         # Core system tweaks (Boot, Bluetooth, Wine)
│   ├── terminal/       # Terminal configurations
│   └── wm/             # Window Managers and desktop shells
└── users/              # User-specific configurations
```

## Adaptation Guide

To adapt these dotfiles to your own system, follow these steps:

### 1. Create a User Profile

Navigate to the `users/` directory and create a folder for your user.
- Create a `default.nix` in `users/YOUR_USER/`.
- Define your `username` and the `modules` you want to enable from the `modules/` folder.
- Add any user-specific `nixosConfig` or `homeConfig`.

### 2. Create a Host Profile

Navigate to the `hosts/` directory and create a folder for your machine.
- Create a `default.nix` in `hosts/YOUR_HOST/`.
- Set your `system` (e.g., `"x86_64-linux"`) and `stateVersion`.
- **Link your user**: Add `users = [ ../../users/YOUR_USER ];` to the host configuration.
- Import your hardware configuration (usually generated via `nixos-generate-config`).
- Here you can add host-specific `nixosConfig` and `homeConfig` aswell.

### 3. Deploy

Once your host and user are defined, you can build your system using the standard flake commands:

```bash
# To build and switch to a NixOS system
sudo nixos-rebuild switch --flake .#YOUR_HOST
# or with nix helper
nh os switch

# To build a standalone Home-Manager configuration
home-manager switch --flake .#YOUR_USER@YOUR_HOST
# or
nh home switch
```

## License

[MIT](/LICENSE)
