{ pkgs }:

let
  version = "3.0.2";
  deps = [
    pkgs.git
    pkgs.gcc
    pkgs.sqlite
  ];
in
pkgs.buildGoModule {
  pname = "buffalo-plugin-pop";
  inherit version;

  src = pkgs.fetchFromGitHub {
    owner = "gobuffalo";
    repo = "buffalo-pop";
    rev = "v${version}";
    sha256 = "sha256-Re7ik04WLUZAzJfXl2hODZq37p2QJICX7PDIMgYm76A=";
  };
  vendorSha256 = "sha256-NKNSiUAgrQNzeOKPFhvMwxTfmgSydfHAIBqZMknO8g8=";

  buildInputs = [
    pkgs.makeWrapper
  ] ++ deps;

  tags = ["sqlite"];

  allowGoReference = true;

  postInstall = ''
    cp -r "$GOPATH" "$out"
    wrapProgram $out/bin/buffalo-pop --argv0 buffalo-pop \
      --set-default GO_BIN ${pkgs.go}/bin/go \
      --suffix PATH : ${pkgs.lib.makeBinPath deps}
  '';

  meta = {
    description = "A plugin to use pop with buffalo CLI";
    homepage = "https://github.com/gobuffalo/buffalo-pop";
  };
}
