{ mkDerivation, base, happstack-server, happstack-server-tls, stdenv }:
mkDerivation {
  pname = "webserver80";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [ base happstack-server happstack-server-tls ];
  license = "unknown";
  hydraPlatforms = stdenv.lib.platforms.none;
}
