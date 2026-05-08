# nixOS-desktop

A modular, flake-based NixOS desktop configuration focused on reproducibility, Wayland, and clean system organization.

This repository contains my full personal NixOS setup, including:

* A modular NixOS configuration
* Custom overlays
* Reproducible development environments
* A Wayland desktop built on Niri
* A custom theming ecosystem
* A flake-based Neovim setup using NVF

---

# Features

* Fully declarative NixOS configuration
* Automatically loaded module system
* Wayland-first desktop using Niri
* Reusable development flakes
* Stable + unstable nixpkgs integration
* Custom overlays and package tweaks
* Flake-based Neovim configuration via NVF
* Zen Browser + Qutebrowser setup
* Multi-monitor support with Kanshi
* Zsh environment with custom aliases
* Managed with `nh`

---

# Repository Structure

```text
.
├── flake.nix                # Main flake entry point
├── modules/                 # System modules (autoloaded)
├── overlays/                # Package overrides
├── nixos/                   # Legacy/base NixOS configs
├── niri/                    # Niri compositor config
├── kanshi/                  # Monitor layout rules
├── alacritty/               # Terminal config + themes
├── qutebrowser/             # Browser configuration
├── nvf/                     # Neovim flake configuration
├── shell/                   # Zsh config and aliases
├── devFlakes/               # Reproducible development environments
├── noctalia/                # Theming ecosystem + plugins
├── Wallpapers/              # Wallpaper collection
└── .lib/                    # Internal helper utilities
```

---

# Flake Architecture

The system uses:

* `nixos-25.11` as the primary stable channel
* `nixos-unstable` for selectively newer packages
* A modular configuration loader for automatic module discovery

The `.lib/load-modules.nix` helper recursively loads all `.nix` files from `modules/`, avoiding large manual import lists and making the configuration easier to scale.

## Inputs

Current flake inputs include:

* NVF
* Zen Browser
* nix-flatpak
* SilentSDDM
* stable + unstable nixpkgs

---

# Module System

The `modules/` directory separates concerns into isolated components.

Examples:

* `boot.nix` — bootloader configuration
* `networking.nix` — networking stack
* `niri.nix` — Wayland compositor setup
* `packages.nix` — installed software
* `shell.nix` — shell environment
* `power-management.nix` — battery and power tuning
* `greeter.nix` — SDDM/login manager
* `kairo.nix` — application-specific configuration

Modules are automatically discovered and loaded through:

```nix
loadModules ./modules
```

This keeps the flake clean while making it easy to add or remove modules.

---

# Desktop Environment

This system is built around:

* **Niri** as the compositor/window manager
* **Alacritty** as the terminal
* **Qutebrowser** and **Zen Browser**
* A Wayland-native workflow

The setup is keyboard-focused and optimized for tiling workflows.

---

# Noctalia

`noctalia/` is a theming ecosystem containing:

* Color palettes
* Templates
* QML plugins/widgets
* Desktop UI bar

It acts as a centralized styling layer for the desktop.

---

# Development Environments

The `devFlakes/` directory contains isolated development environments.

Current examples:

* Java
* Python data analysis

Each environment is independently reproducible using:

```bash
nix develop ./devFlakes/<environment>
```

Some development flakes are symlinked to active project directories for easier maintenance.

---

# Overlays

Custom overlays are used for:

* Steam tweaks
* Flameshot modifications
* Qutebrowser packaging changes

Defined in:

```text
overlays/
```

and injected into the system package set during flake evaluation.

---

# Usage

## Rebuild the system

```bash
nh os switch
```

## Update flake inputs

```bash
nh os switch --update
```

## Enter a development shell

devenv is included for automatic dev shell integration.

---

# Design Philosophy

## Everything is reproducible

System configuration, editor setup, shell environments, and development tooling are all managed declaratively.

## Modular over monolithic

Features are isolated into focused modules instead of one massive configuration file.

## Stable core, selective instability

Stable nixpkgs is used for the main system while unstable packages are selectively imported where newer software is useful.

---

# Notes

* Some configuration is hardware-specific
* This setup evolves frequently and doubles as a learning/project environment
* Many components are experimental by design

---

# Future Ideas

* Hjem integration
* Shared module library
* Public reusable dev flakes
* Host profiles for additional machines
* Integrating my NixOS server into this flake instead of maintaining a separate repository

