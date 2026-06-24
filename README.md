# express-messenger-nix

Nix flake for [eXpress Messenger](https://express.ms/).
Repackages the official AppImage.

## Quick Start

**Try it without installing:**
```bash
nix run github:blackfan321/express-messenger-nix
```

**Install to your profile:**
```bash
nix profile install github:blackfan321/express-messenger-nix
```

## Installation

### NixOS Flake

```nix
{
  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };
    express-messenger = {
      url = "github:blackfan321/express-messenger-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  }

  outputs = { nixpkgs, express-messenger, ... }: {
    nixosConfigurations.hostname = nixpkgs.lib.nixosSystem {
      modules = [{
        environment.systemPackages = [
          express-messenger.packages.x86_64-linux.express
        ];
      }];
    };
  };
}
```

### Home Manager

```nix
{ inputs, pkgs, ... }:
{
  home.packages = [
    inputs.express-messenger.packages.x86_64-linux.express
  ];
}
```

## Platforms

`x86_64-linux`

## Justfile

Requires [just](https://github.com/casey/just) and `wget`.

| Command | Description |
|---|---|
| `just update_application` | Checks for a newer release and bumps `version` and `hash` in `express.nix` |
| `just get_latest_appimage_version` | Prints the latest AppImage version |
| `just pull_appimage <version>` | Downloads the AppImage for a given version and prints its sha256 hash |
| `just pull_latest_appimage` | Downloads the latest AppImage and prints its sha256 hash |
| `just cleanup` | Removes downloaded AppImages from the repo root |
