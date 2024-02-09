_: final: prev: let
  inherit (builtins) mapAttrsToList filterAttrs;
  inherit (prev.lib) mkIf mkMerge mkOption strings;
  inherit (prev.lib.types) bool;
  mine = rec {
    disabled = {enable = false;};
    enabled = {enable = true;};
    ifThenElse = cond: t: f:
      if cond
      then t
      else f;
    mkOpt = type: default: description:
      mkOption {inherit type default description;};
    mkOpt' = type: default: mkOpt type default null;
    mkBoolOpt = mkOpt bool;
    mkBoolOpt' = mkOpt' bool;
    mkIfElse = p: yes: no:
      mkMerge [
        (mkIf p yes)
        (mkIf (!p) no)
      ];
    mkPxeMenu = args:
      ''
        UI menu.c32
        TIMEOUT 300
      ''
      + strings.concatStringsSep "\n" (mapAttrsToList
        (
          name: value: ''
            LABEL ${name}
              MENU LABEL ${value.content.label}
              KERNEL ${value.content.kernel}
              append ${value.content.append}
          ''
        )
        (filterAttrs (_: v: v.condition) args));
  };
in {
  lib = prev.lib // {inherit mine;};
}
