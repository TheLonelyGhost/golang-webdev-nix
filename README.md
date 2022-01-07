# Nix Flake: Go-based web development tools

Packages included:

- [`buffalo`](https://gobuffalo.io)
- [`buffalo-plugin-heroku`](https://github.com/gobuffalo/buffalo-heroku)
- [`buffalo-plugin-pop`](https://github.com/gobuffalo/buffalo-pop)
- [`pop`](https://github.com/gobuffalo/pop)

## Usage

### With Flakes

Add this repo to your `flake.nix` inputs like:

```nix
{
  # ...
  inputs.golang-webdev.url = "github:thelonelyghost/golang-webdev-nix";
  # ...

  outputs = { self, nixpkgs, flake-utils, golang-webdev, ...}@attrs:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
      };
      go = golang-webdev.packages."${system}";
    in {
      devShell = pkgs.mkShell {
        nativeBuildInputs = [
          pkgs.bashInteractive
          go.buffalo
        ];
      };
    });
}
```

**Updating:** Anytime you want to update what golang-webdev offers, run `nix flake lock --update-input golang-webdev` and rebuild your nix expression acccordingly.

### Without Flakes

If you're not yet using [Nix Flakes][flakes], such as with [`home-manager`][home-manager], here's how you can include it:

1. Install [`niv`][niv] and run `niv init`
2. Run `niv add thelonelyghost/golang-webdev-nix --name golang-webdev`
3. Include the following in your code:

```nix
{ lib, config, ... }:

let
  sources = import ./nix/sources.nix {};
  pkgs = import sources.nixpkgs {};

  golang-webdev = (import (pkgs.fetchGitHub { inherit (sources.golang-webdev) owner repo rev sha256; })).outputs.packages."${builtings.currentSystem}";
in
{
  home.packages = [
    golang-webdev.buffalo
  ];
}
```

**Updating:** Anytime you want to update what golang-webdev offers, run `niv update golang-webdev` and rebuild your nix expression acccordingly.

[flakes]: https://github.com/NixOS/nix/blob/master/src/nix/flake.md
[home-manager]: https://github.com/nix-community/home-manager
[niv]: https://github.com/nmattia/niv
