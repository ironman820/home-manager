{
  pkgs,
  stdenv,
  ...
}: let
  myPythonPackages = py: with py; [aiohttp black debugpy flake8 pydbus pylint qtile qtile-extras setuptools tendo];
  myPython = pkgs.python3.withPackages myPythonPackages;
in
  stdenv.mkDerivation {
    name = "ironman-shell";
    nativeBuildInputs = with pkgs; [nix-index nix-tree myPython pyright];

    shellHook = ''
      export PYTHON_ENV="${myPython}/bin"
    '';
  }
