# Nix Flake: Go-based web development tools

Packages included:

- [`buffalo`](https://gobuffalo.io)
- [`buffalo-plugin-heroku`](https://github.com/gobuffalo/buffalo-heroku)
- [`buffalo-plugin-pop`](https://github.com/gobuffalo/buffalo-pop)
- [`pop`](https://github.com/gobuffalo/pop)

## Usage

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
