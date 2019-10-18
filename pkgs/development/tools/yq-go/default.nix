# This file was generated by https://github.com/kamilchm/go2nix v1.3.0
{ stdenv, buildGoPackage, fetchFromGitHub }:

# buildGoModule is not supported by the project
# See https://github.com/mikefarah/yq/issues/227
buildGoPackage rec {
  pname = "yq-go";
  version = "2.4.0";

  goPackagePath = "gopkg.in/mikefarah/yq.v2";

  src = fetchFromGitHub {
    owner = "mikefarah";
    rev = version;
    repo = "yq";
    sha256 = "0nizg08mdpb8g6hj887kk5chljba6x9v0f5ysqf28py511yp0dym";
  };

  goDeps = ./deps.nix;

  postInstall = ''
    mv $bin/bin/yq.v2 $bin/bin/yq
  '';

  meta = with stdenv.lib; {
    description = "Portable command-line YAML processor";
    homepage = http://mikefarah.github.io/yq/;
    license = [ licenses.mit ];
    maintainers = [ maintainers.lewo ];
  };
}
