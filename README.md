# NixOS & Home Manager Configurations

Personal NixOS and Home Manager configurations for multiple hosts and environments.

## Overview

This repository contains modular Nix configurations supporting:
- **NixOS systems** with WSL support
- **Home Manager** configurations for Linux and macOS
- **Multiple environments**: desktop, server, work, and development setups
- **Cross-platform support**: x86_64-linux and aarch64-darwin

## Hosts

### NixOS Systems
- **sunflower** - WSL-enabled NixOS system

### Home Manager Configurations
- **vps02** - Server environment (x86_64-linux)
- **sunflower** - Desktop/WSL environment (x86_64-linux)
- **work_mac** - Work macOS setup (aarch64-darwin)
- **work_ubuntu** - Work Ubuntu environment (x86_64-linux)
- **hydrangea** - Personal macOS setup (aarch64-darwin)

## Structure

```
├── flake.nix              # Main flake configuration
├── hosts/                 # Host-specific configurations
│   ├── default.nix        # Host definitions
│   ├── sunflower/         # WSL NixOS system
│   ├── vps02/             # Server configuration
│   ├── work_mac/          # Work macOS
│   ├── work_ubuntu/       # Work Ubuntu
│   └── hydrangea/         # Personal macOS
├── home-manager/          # Home Manager modules
│   ├── base/              # Base configuration
│   ├── darwin/            # macOS-specific
│   ├── desktop/           # Desktop environment
│   ├── server/            # Server-specific
│   └── work/              # Work environment
├── modules/               # System modules
│   ├── core/              # Core system settings
│   ├── darwin/            # macOS system modules
│   ├── desktop/           # Desktop environment modules
│   └── programs/          # Program configurations
└── pkgs/                  # Custom packages
```

## Key Features

- **Hyprland** desktop environment with custom configurations
- **Secure Boot** support via Lanzaboote
- **Input remapping** with xremap
- **Multi-language support** with fcitx5
- **Development tools** and environments
- **Consistent theming** across all systems

## Usage

### Building NixOS Configuration
```bash
sudo nixos-rebuild switch --flake .#sunflower
```

### Building Home Manager Configuration
```bash
# Using home-manager directly
home-manager switch --flake .#tnmt@sunflower

# Using nh (recommended)
nh home switch . -c tnmt@hydrangea
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
- nixpkgs (unstable, stable, and darwin channels)
- home-manager
- nix-darwin
- nixos-hardware
- hyprland
- lanzaboote
- nixos-wsl
- xremap

## License

Personal configuration files - use at your own discretion.