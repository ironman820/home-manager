{ lib
, inputs
, fetchFromGitHub
, pkgs
, stdenv
}:
let
    inherit (pkgs.vimUtils) buildVimPlugin;
in buildVimPlugin rec {
    name = "undotree";
    src = inputs.nvim-undotree;
}
