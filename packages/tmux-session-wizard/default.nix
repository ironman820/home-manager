{ lib
, inputs
, fetchFromGitHub
, pkgs
, stdenv
}:

let
  inherit (pkgs.tmuxPlugins) mkTmuxPlugin;
in mkTmuxPlugin rec {
  pluginName = "tmux-session-wizard";
  rtpFilePath = "session-wizard.tmux";
  src = inputs.tmux-session-wizard;
  version = "2.6.0";
}
