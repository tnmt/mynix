# Project Structure

## Root Level
- `flake.nix`: Main flake configuration defining inputs, outputs, and build logic
- `flake.lock`: Lock file for reproducible builds
- `treefmt.toml`: Code formatting configuration
- `.gitignore`: Git ignore patterns

## Core Directories

### `/hosts/`
Host-specific configurations for different machines.
- `default.nix`: Central host definitions with helper functions `mkNixosSystem` and `mkHomeManagerConfiguration`
- `<hostname>/`: Individual host configurations
  - `nixos.nix`: NixOS system configuration (if applicable)
  - `home-manager.nix`: Home Manager user configuration

**Current hosts:**
- `sunflower`: WSL NixOS system (x86_64-linux)
- `vps02`: Server environment (x86_64-linux)  
- `work_mac`: Work macOS setup (aarch64-darwin)
- `work_ubuntu`: Work Ubuntu environment (x86_64-linux)
- `hydrangea`: Personal macOS setup (aarch64-darwin)

### `/home-manager/`
Modular Home Manager configurations organized by environment type.
- `base/`: Core user configuration shared across all environments
- `darwin/`: macOS-specific user configurations
- `desktop/`: Desktop environment configurations (Hyprland, terminals, etc.)
- `server/`: Server-specific user configurations
- `work/`: Work environment configurations

### `/modules/`
System-level NixOS modules organized by functionality.
- `core/`: Essential system settings (i18n, network, nix config, security)
- `darwin/`: macOS system modules
- `desktop/`: Desktop environment modules (fonts, sound, input methods)
- `programs/`: Program-specific system configurations
- `remotebuild/`: Remote build configurations

### `/pkgs/`
Custom package definitions and overlays.
- `default.nix`: Package exports and overlays

## Architecture Patterns

### Module Organization
- Each directory contains a `default.nix` that imports all modules in that directory
- Use `imports = [ ./module.nix ];` pattern for module composition
- Separate concerns: system vs user, platform-specific vs generic

### Configuration Inheritance
- Base configurations are extended by environment-specific modules
- Host configurations compose multiple environment modules as needed
- Use `specialArgs` and `extraSpecialArgs` to pass custom parameters

### Naming Conventions
- Host configurations: `<user>@<hostname>` for Home Manager
- File names: lowercase with hyphens for multi-word names
- Directory names: singular nouns (e.g., `program/` not `programs/`)

### File Structure Within Modules
```
module-name/
├── default.nix          # Main module definition and imports
├── specific-feature.nix # Feature-specific configurations
└── config-files/        # Static configuration files (if needed)
```

## Configuration Flow
1. `flake.nix` defines available configurations
2. `hosts/default.nix` creates system/home-manager configurations
3. Host-specific files in `hosts/<hostname>/` define the module composition
4. Modules from `modules/` (system) and `home-manager/` (user) are imported
5. Custom packages from `pkgs/` are available to all configurations