{ pkgs, stdenv, ... }:
let
  myPythonPackages = py: with py; [ black debugpy flake8 pylint qtile ];
  myPython = pkgs.python3.withPackages myPythonPackages;
in stdenv.mkDerivation {
  name = "ironman-shell";
  nativeBuildInputs = with pkgs; [ nix-index nix-tree myPython pyright ];

  shellHook = ''
    export PYTHON_ENV="${myPython}/bin"
  '';
}
