{ pkgs, ... }:
let
  inherit (pkgs.python3Packages) buildPythonApplication;
  name = "s";
in buildPythonApplication {
  inherit name;
  pname = name;
  version = "0.1";
  src = ./.;
}
