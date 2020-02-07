# Copyright 2018 Maximilian Huber <oss@maximilian-huber.de>
# SPDX-License-Identifier: MIT
{ pkgs ? import <nixpkgs> {}, stdenv ? pkgs.stdenv }:

stdenv.mkDerivation rec {
  version = "1.0";
  name = "my-xmonad-misc-${version}";

  src = ./.;

  buildPhase = "";

  installPhase = ''
    share=$out/share
    bin=$out/bin
    mkdir -p $share $bin

    cp bin/* $bin
    cp share/* $share
  '';
}
