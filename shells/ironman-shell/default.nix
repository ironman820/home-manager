{ pkgs, stdenv, ... }:
  let
    myPythonPackages = py:
      with py; [
        black
        flake8
        qtile
      ];
  in
stdenv.mkDerivation {
  name = "ironman-shell";
  nativeBuildInputs = with pkgs; [
    nix-index
    nix-tree
    (python3.withPackages myPythonPackages)
  ];

  # shellHook = ''
  #   export NIX_PATH=nixpkgs=https://github.com/nixos/nixpkgs/archive/e516ffb.tar.gz
  # '';
}
