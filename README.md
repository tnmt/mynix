# NixOS, nix-darwin & Home Manager Configurations

Personal Nix configurations for Linux and macOS hosts, built as a single flake.

## Overview

This repository contains:
- NixOS system definitions for a desktop machine and a WSL machine
- nix-darwin system definitions for two macOS hosts
- standalone Home Manager configurations for Linux and macOS
- shared modules for core settings, desktop features, services, and user programs
- secrets management with `sops-nix`

Supported platforms are `x86_64-linux` and `aarch64-darwin`.

## Input Strategy

- Linux system and Home Manager targets use `nixpkgs` with `home-manager`
- macOS system and Home Manager targets use `nixpkgs-darwin` with `home-manager-darwin`
- nix-darwin tracks `master` together with `nixpkgs-darwin` on `nixpkgs-unstable`

## Hosts

### `nixosConfigurations`
- `sunflower`: WSL-based NixOS host
- `dahlia`: desktop/laptop-style NixOS host with Hyprland

### `darwinConfigurations`
- `work_mac`: work macOS machine
- `hydrangea`: personal macOS machine

### `homeConfigurations`
- `tnmt@work_ubuntu`: Home Manager for Ubuntu

## Repository Layout

```text
.
├── flake.nix              # Flake inputs, outputs, devShell, formatter, helper app
├── hosts/                 # Concrete host entrypoints
├── home-manager/          # Reusable Home Manager modules
├── modules/               # Reusable NixOS and cross-host modules
├── profiles/              # Role-based profiles (nixos, home-manager, darwin)
├── secrets/               # sops-encrypted secret files
├── themes/                # Shared theme definitions
└── treefmt.toml           # Formatter configuration
```

The important split is:
- `hosts/` selects a machine and wires modules together
- `modules/` holds lower-level reusable system pieces
- `home-manager/` holds reusable user-level pieces
- `profiles/` bundles opinionated groups of modules per layer (nixos, home-manager, darwin)

## Notable Features

- Hyprland desktop setup with Waybar, Walker, Mako, Hyprlock, Hypridle, and Wlogout
- `greetd` + `tuigreet` login flow for the Linux desktop profile
- `sops-nix` secrets for both system and Home Manager configs
- Input remapping with `kanata` (Linux) and Karabiner-Elements (macOS)
- Shared Tokyo Night Storm theme wiring
- NUR overlay usage for custom packages such as `oneaws`, `ccusage`, `gogcli`, and `kagiana`

## Usage

### NixOS

```bash
# Recommended
nh os switch . -H dahlia

# Directly
sudo nixos-rebuild switch --flake .#dahlia
```

### nix-darwin

```bash
# Recommended; also activates the matching Home Manager user.
nh darwin switch . -H hydrangea

# Directly
darwin-rebuild switch --flake .#hydrangea
```

### Home Manager

Standalone Home Manager outputs are only for non-Darwin hosts. Darwin hosts activate Home Manager through `nh darwin switch`.

```bash
# Recommended
nh home switch . -c tnmt@work_ubuntu

# Directly
home-manager switch --flake .#tnmt@work_ubuntu
```

### Development helpers

```bash
# Enter the dev shell
nix develop

# Format Nix and TOML files
nix fmt

# Update a flake input
update-input nixpkgs github:NixOS/nixpkgs/nixos-unstable

# Run the desktop VM for dahlia
nix run .#dahlia-vm
```

## Secrets

This repo expects `sops-nix` with age keys available on the target machine.

- host/system-specific secrets live in `secrets/<hostname>.yaml`
- Home Manager identity secrets use `secrets/personal.yaml` by default, with work-specific values in `secrets/work.yaml`
- shared Home Manager values, such as service endpoints or API keys, live in `secrets/common.yaml`

Builds may evaluate without secrets in some cases, but activation on real machines assumes the corresponding key material exists.

## CI

GitHub Actions currently checks:
- formatting via `nix fmt`
- NixOS builds for `sunflower` and `dahlia`
- Home Manager build for `tnmt@work_ubuntu`

Darwin system and Home Manager targets are excluded from CI because they require macOS runners.

## License

Personal configuration files. Reuse with care.
