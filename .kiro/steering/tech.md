# Technology Stack

## Build System
- **Nix Flakes**: Primary build and configuration management system
- **Home Manager**: User environment and dotfiles management
- **nix-darwin**: macOS system configuration (when applicable)

## Core Technologies
- **NixOS**: Linux distribution and system configuration
- **Nix**: Functional package manager and configuration language
- **Hyprland**: Wayland compositor for desktop environments
- **WSL**: Windows Subsystem for Linux support

## Key Dependencies
- `nixpkgs` (unstable, stable, darwin channels)
- `home-manager`: User environment management
- `nix-darwin`: macOS system management
- `nixos-hardware`: Hardware-specific configurations
- `hyprland`: Wayland compositor
- `lanzaboote`: Secure Boot support
- `nixos-wsl`: WSL integration
- `xremap`: Input remapping

## Development Tools
- **nh**: Nix helper for easier system management
- **treefmt**: Code formatting orchestrator
- **nixfmt-rfc-style**: Nix code formatter
- **taplo**: TOML formatter

## Common Commands

### System Management
```bash
# NixOS system rebuild
sudo nixos-rebuild switch --flake .#<hostname>
# or using nh (recommended)
nh os switch . -H <hostname>

# Home Manager rebuild
home-manager switch --flake .#<user>@<hostname>
# or using nh (recommended)
nh home switch . -c <user>@<hostname>
```

### Development
```bash
# Enter development shell
nix develop

# Format code
nix fmt

# Update specific flake input
nix flake lock --override-input <input> <url>
```

### Build and Test
```bash
# Build specific configuration
nix build .#nixosConfigurations.<hostname>.config.system.build.toplevel
nix build .#homeConfigurations."<user>@<hostname>".activationPackage
```

## Code Style
- Use `nixfmt-rfc-style` for Nix code formatting
- Follow functional programming patterns in Nix expressions
- Modular configuration structure with clear separation of concerns