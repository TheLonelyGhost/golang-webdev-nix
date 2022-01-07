{ pkgs, nodejs ? pkgs.nodejs-16_x, yarn ? pkgs.yarn }:

let
  version = "0.18.1";

  buffalo-pop = pkgs.callPackage ./buffalo-plugin-pop.nix {};

  deps = [
    pkgs.git
    pkgs.gcc
    pkgs.sqlite
    nodejs
    yarn
    buffalo-pop
  ];
in
pkgs.buildGoModule {
  pname = "buffalo";
  inherit version;

  src = pkgs.fetchFromGitHub {
    owner = "gobuffalo";
    repo = "cli";
    rev = "v${version}";
    sha256 = "sha256-DqZGzVRMp/yNPRWzp8zVRJqJ4jon5g5uGEsV9GRn8CE=";
  };

  buildInputs = [
    pkgs.makeWrapper
  ] ++ deps;

  tags = [ "sqlite" ];

  allowGoReference = true;

  vendorSha256 = "sha256-ZEEGvNcDQAjZOIuQyeE5v6+1TTsHYMRni8Fuj+feups=";

  postInstall = ''
    cp -r "$GOPATH" "$out"
    wrapProgram $out/bin/buffalo --argv0 buffalo \
      --set-default GO_BIN ${pkgs.go}/bin/go \
      --suffix PATH : ${pkgs.lib.makeBinPath deps}
  '';

  meta = {
    description = "An MVC framework in Go, inspired by Ruby on Rails";
    homepage = "https://gobuffalo.io";
  };
}
