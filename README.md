# NixOS, nix-darwin & Home Manager Configurations

Personal Nix configurations for Linux and macOS hosts, built as a single flake.

## Overview

This repository contains:
- NixOS system definitions for a desktop machine and a WSL machine
- nix-darwin system definitions for two macOS hosts
- shared modules for core settings, desktop features, services, and user programs
- secrets management with `sops-nix`

Supported platforms are `x86_64-linux` and `aarch64-darwin`.

Standalone `homeConfigurations` outputs are currently kept only for compatibility; active Home Manager setups are integrated into the NixOS and nix-darwin hosts defined in this flake.

## Input Strategy

- Linux system and Home Manager targets use `nixpkgs` with `home-manager`
- macOS system and Home Manager targets use `nixpkgs-darwin` with `home-manager-darwin`
- nix-darwin tracks `master` together with `nixpkgs-darwin` on `nixpkgs-unstable`

## Hosts

### `nixosConfigurations`
- `sunflower`: WSL-based NixOS host
- `dahlia`: personal NixOS laptop with Hyprland

### `darwinConfigurations`
- `hydrangea`: personal macOS machine

### At a glance

| Host | Platform | Role |
| --- | --- | --- |
| `sunflower` | NixOS / WSL | personal Linux-on-WSL environment |
| `dahlia` | NixOS | personal laptop with Hyprland |
| `hydrangea` | nix-darwin | personal macOS machine |

Work-related hosts (`work_mac`, `work_vm`) live in the private `tnmt-work-flake` repository, which consumes this flake via `mynix.lib`.

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

### Prerequisites

Before switching a host, make sure the target machine has:
- Nix with flakes enabled
- `nh` available if you want to use the recommended commands below
- the corresponding `age` key material required by `sops-nix`

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

### Development helpers

```bash
# Enter the dev shell
nix develop

# Format Nix and TOML files
nix fmt

# Update a flake input (from the dev shell)
update-input nixpkgs github:NixOS/nixpkgs/nixos-unstable

# Run the desktop VM for dahlia
nix run .#dahlia-vm
```

## Secrets

This repo expects `sops-nix` with age keys available on the target machine.

- host/system-specific secrets live in `secrets/hosts/<hostname>.yaml`
- Home Manager identity secrets use `secrets/roles/personal.yaml` by default
- shared Home Manager values, such as service endpoints or API keys, live in `secrets/common.yaml`

Builds may evaluate without secrets in some cases, but activation on real machines assumes the corresponding key material exists.

## CI

GitHub Actions currently checks:
- formatting via `nix fmt`
- lint via `deadnix` and `statix`
- NixOS builds for `sunflower` and `dahlia`

Darwin system and Home Manager targets are excluded from CI because they require macOS runners.

## License

Personal configuration files. Reuse with care.
