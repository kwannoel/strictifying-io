{ pkgs ? import <nixpkgs> {} }:

let
  haskellPackages = pkgs.haskellPackages;

in
  pkgs.mkShell {
    nativeBuildInputs = [
      # Haskell tools
      haskellPackages.ghc
      haskellPackages.ghcid

      # Profiling tools
      haskellPackages.threadscope
    ];
  }
