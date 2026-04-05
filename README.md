# NixOS, nix-darwin & Home Manager Configurations

Personal Nix configurations for multiple hosts and environments.

## Overview

This repository contains modular Nix configurations supporting:
- **NixOS systems** (desktop, WSL)
- **nix-darwin** for macOS system-level management
- **Home Manager** configurations for Linux and macOS
- **Secrets management** with sops-nix
- **Cross-platform support**: x86_64-linux and aarch64-darwin

## Hosts

### NixOS Systems
- **sunflower** - WSL-enabled NixOS system (x86_64-linux)
- **dahlia** - Desktop system with Hyprland (x86_64-linux)

### nix-darwin Systems
- **work_mac** - Work macOS setup (aarch64-darwin)
- **hydrangea** - Personal macOS (aarch64-darwin)

### Home Manager Configurations
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
│   ├── work_mac/          # Work macOS (nix-darwin)
│   ├── work_ubuntu/       # Work Ubuntu
│   └── hydrangea/         # Personal macOS (nix-darwin)
├── home-manager/          # Home Manager modules
│   ├── base/              # Base configuration (shell, git, etc.)
│   ├── base-nixos/        # NixOS-specific Home Manager base
│   ├── darwin/            # macOS-specific (karabiner, etc.)
│   ├── desktop/           # Desktop environment (hyprland, terminals)
│   ├── devel/             # Development tools (neovim, etc.)
│   └── work/              # Work environment
├── modules/               # System modules
│   ├── core/              # Core system settings
│   ├── desktop/           # Desktop environment (fcitx5, sound, etc.)
│   ├── programs/          # Program configurations
│   ├── services/          # Service configurations (mackerel-agent, etc.)
│   └── remotebuild/       # Remote build cache
├── profiles/              # Reusable NixOS profiles
├── secrets/               # sops-encrypted secrets
└── themes/                # Theme definitions (Tokyo Night Storm)
```

## Key Features

- **Hyprland** desktop environment with Waybar, Walker, Dunst
- **Secure Boot** support via Lanzaboote
- **sops-nix** for secrets management (age encryption)
- **Mackerel** monitoring agent integration
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
home-manager switch --flake .#tnmt@work_ubuntu

# Using nh (recommended)
nh home switch . -c tnmt@work_ubuntu
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

GitHub Actions automatically checks the following:

- `nix flake check` (evaluates devShells, formatter, and checks)
- Code formatting verification (`nix fmt`)
- NixOS builds: sunflower, dahlia
- Home Manager build: tnmt@work_ubuntu

Darwin targets (work_mac, hydrangea) are currently excluded as they require a macOS runner.

## License

Personal configuration files - use at your own discretion.
