{ pkgs }:

let
  version = "1.0.9";
  deps = [
    pkgs.git
  ];
in
pkgs.buildGoModule {
  pname = "buffalo-plugin-heroku";
  inherit version;

  src = pkgs.fetchFromGitHub {
    owner = "gobuffalo";
    repo = "buffalo-heroku";
    rev = "v${version}";
    sha256 = "sha256-z6ceKjkOFfDPUTIw0YNgt5LC/S6DYLyyaelU6R8s0Pw=";
  };

  buildInputs = [
    pkgs.makeWrapper
  ] ++ deps;

  vendorSha256 = "sha256-U3xjMDCP53wa8VU7w2o4y0CnoFbjzGZuGmTLVx90HSw=";

  postInstall = ''
    cp -r "$GOPATH" "$out"
    wrapProgram $out/bin/buffalo-heroku --argv0 buffalo-heroku \
      --suffix PATH : ${pkgs.lib.makeBinPath deps}
  '';

  meta = {
    description = "Sets up and deploys Buffalo apps to Heroku";
    homepage = "https://github.com/gobuffalo/buffalo-heroku";
  };
}
