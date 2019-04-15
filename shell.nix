{ pkgs ? import <nixpkgs-unstable> { }, ... }:

pkgs.stdenv.mkDerivation rec {
  name = "env";
  env = pkgs.buildEnv { name = name; paths = buildInputs; };

  buildInputs = with pkgs; [
    dmd
    dub
  ];
}
