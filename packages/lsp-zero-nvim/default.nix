{ lib
, inputs
, fetchFromGitHub
, pkgs
, stdenv
}:
let
    inherit (pkgs.vimUtils) buildVimPlugin;
in buildVimPlugin rec {
    name = "lsp-zero-nvim";
    src = inputs.lsp-zero-nvim;
}
