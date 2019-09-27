{ mkDerivation, base, happstack-server, stdenv }:
mkDerivation {
  pname = "webserver80";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [ base happstack-server ];
  license = "unknown";
  hydraPlatforms = stdenv.lib.platforms.none;
}
