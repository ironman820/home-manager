{ channels, ... }:
self: super:
let
  inherit (builtins) fetchurl;
  inherit (super.python3Packages) buildPythonPackage nodeenv;
in {
  python3Packages = super.python3Packages // {
    inherit (channels.unstable.python3Packages) qtile;
    "pyright" = buildPythonPackage {
      pname = "pyright";
      version = "1.1.337";
      src = fetchurl {
        url =
          "https://files.pythonhosted.org/packages/18/8d/43d0d60671fb6a91bad39e02dcf89da8e105709ad5d8628846886ceee2f4/pyright-1.1.337-py3-none-any.whl";
        sha256 = "0npnnmxfydd7wg884827kx3i64n9r5cag4w3da0qy9cp2zvlxgcc";
      };
      format = "wheel";
      doCheck = false;
      buildInputs = [ ];
      checkInputs = [ ];
      nativeBuildInputs = [ ];
      propagatedBuildInputs = [ nodeenv ];
    };
    qtile-extras =
      channels.unstable.python3Packages.qtile-extras.overridePythonAttrs
      (old: { disabledTestPaths = [ "test/widget/test_strava.py" ]; });
  };
}
