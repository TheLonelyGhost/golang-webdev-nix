{ pkgs }:

let
  version = "6.0.1";
  deps = [
    pkgs.gcc
    pkgs.sqlite
  ];
in
pkgs.buildGoModule {
  pname = "pop";
  inherit version;

  src = pkgs.fetchFromGitHub {
    owner = "gobuffalo";
    repo = "pop";
    rev = "v${version}";
    sha256 = "sha256-KN46doz7D32S3FkpsDw9J/6TSV+vxIU7K9p9k/34Ndc=";
  };
  vendorSha256 = "sha256-afTgv1iq7W4ddNuB+xBdw+jADHF1zfduYWd5yGOrhuk=";

  buildInputs = [
    pkgs.makeWrapper
  ] ++ deps;

  tags = ["sqlite"];

  postInstall = ''
    cp -r "$GOPATH" "$out"
    wrapProgram $out/bin/soda --argv0 soda \
      --suffix PATH : ${pkgs.lib.makeBinPath deps}
  '';

  meta = {
    description = "A Tasty Treat For All Your Database Needs";
    homepage = "https://github.com/gobuffalo/pop";
  };
}
