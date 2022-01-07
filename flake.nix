{
  description = "Web development tools in Go for nix-based workstations";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.flake-compat = {
    url = "github:edolstra/flake-compat";
    flake = false;
  };

  outputs = { self, nixpkgs, flake-utils, flake-compat }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {
          inherit system;
        };
      in
        {
          devShell = pkgs.mkShell {
            nativeBuildInputs = [
              pkgs.bashInteractive
              pkgs.gnumake
            ];
            buildInputs = [];
          };

          packages = {
            buffalo = import ./packages/buffalo.nix { inherit pkgs; };
            buffalo-plugin-pop = import ./packages/buffalo-plugin-pop.nix { inherit pkgs; };
            buffalo-plugin-heroku = import ./packages/buffalo-plugin-heroku.nix { inherit pkgs; };
            pop = import ./packages/pop.nix { inherit pkgs; };
          };
        }
    );
}
