# NixOS, nix-darwin & Home Manager Configurations

Personal Nix configurations for multiple hosts and environments.

## Overview

This repository contains modular Nix configurations supporting:
- **NixOS systems** (desktop, server, WSL)
- **nix-darwin** for macOS system-level management
- **Home Manager** configurations for Linux and macOS
- **Secrets management** with sops-nix
- **Selfhosted services** (Forgejo, AdGuard, Atuin Server, etc.)
- **Cross-platform support**: x86_64-linux and aarch64-darwin

## Hosts

### NixOS Systems
- **sunflower** - WSL-enabled NixOS system (x86_64-linux)
- **dahlia** - Desktop system with Hyprland (x86_64-linux)
- **vps01** - VPS with selfhosted services (x86_64-linux)
- **test-vm** - VM testing environment (x86_64-linux)

### nix-darwin Systems
- **work_mac** - Work macOS setup (aarch64-darwin)

### Home Manager Configurations
- **tnmt@vps02** - Server environment (x86_64-linux)
- **tnmt@sunflower** - Desktop/WSL environment (x86_64-linux)
- **tsunematsu@work_mac** - Work macOS (aarch64-darwin)
- **tnmt@work_ubuntu** - Work Ubuntu environment (x86_64-linux)
- **tnmt@hydrangea** - Personal macOS (aarch64-darwin)

## Structure

```
├── flake.nix              # Main flake configuration
├── hosts/                 # Host-specific configurations
│   ├── default.nix        # Host definitions
│   ├── sunflower/         # WSL NixOS system
│   ├── dahlia/            # Desktop (Hyprland)
│   ├── vps01/             # VPS with selfhosted services
│   ├── vps02/             # Server configuration
│   ├── test-vm/           # VM testing
│   ├── work_mac/          # Work macOS (nix-darwin)
│   ├── work_ubuntu/       # Work Ubuntu
│   └── hydrangea/         # Personal macOS
├── home-manager/          # Home Manager modules
│   ├── base/              # Base configuration (shell, git, neovim, etc.)
│   ├── darwin/            # macOS-specific (karabiner, etc.)
│   ├── desktop/           # Desktop environment (hyprland, terminals)
│   ├── server/            # Server-specific
│   └── work/              # Work environment
├── modules/               # System modules
│   ├── core/              # Core system settings
│   ├── darwin/            # macOS system modules
│   ├── desktop/           # Desktop environment (fcitx5, greetd, sound)
│   ├── programs/          # Program configurations
│   ├── selfhosted/        # Selfhosted services
│   └── remotebuild/       # Remote build cache
├── secrets/               # sops-encrypted secrets
├── themes/                # Theme definitions (Tokyo Night Storm)
└── pkgs/                  # Custom packages
```

## Key Features

- **Hyprland** desktop environment with Waybar, Walker, Dunst
- **Secure Boot** support via Lanzaboote
- **sops-nix** for secrets management (age encryption)
- **Selfhosted services**: Forgejo, AdGuard, Atuin Server, Nginx, CouchDB, MySQL, Postfix, Fail2ban, Tailscale
- **Input remapping** with xremap / Karabiner-Elements
- **Multi-language support** with fcitx5
- **Multiple terminal emulators**: Alacritty, foot, ghostty, kitty
- **Theme system** with Tokyo Night Storm
- **Greetd** display manager with tuigreet

## Usage

### Building NixOS Configuration
```bash
# Using nixos-rebuild directly
sudo nixos-rebuild switch --flake .#sunflower

# Using nh (recommended)
nh os switch . -H sunflower
```

### Building nix-darwin Configuration
```bash
# Using darwin-rebuild directly
darwin-rebuild switch --flake .#work_mac

# Using nh (recommended)
nh darwin switch . -H work_mac
```

### Building Home Manager Configuration
```bash
# Using home-manager directly
home-manager switch --flake .#tnmt@sunflower

# Using nh (recommended)
nh home switch . -c tnmt@sunflower
```

### Development Shell
```bash
nix develop
```

### Formatting Code
```bash
nix fmt
```

## Dependencies

This configuration uses several external inputs:
- nixpkgs (unstable), nixpkgs-stable, nixpkgs-darwin
- home-manager
- nix-darwin
- nixos-hardware
- sops-nix
- hyprland
- lanzaboote
- nixos-wsl
- xremap
- ccusage, oneaws (custom flakes)

## CI

GitHub Actions で以下を自動チェック:

- `nix flake check` (devShells, formatter, checks の評価)
- コードフォーマットの確認 (`nix fmt`)
- NixOS ビルド: sunflower, dahlia
- Home Manager ビルド: tnmt@work_ubuntu

darwin 系ターゲット (work_mac, hydrangea) は macOS ランナーが必要なため現在は除外。

## License

Personal configuration files - use at your own discretion.
