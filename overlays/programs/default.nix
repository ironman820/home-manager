{channels, ...}: final: prev: {
  inherit (prev.mine) idracclient switchssh;
}
