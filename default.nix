{ mkDerivation, base, random, happstack-server, happstack-server-tls, process, stdenv }:
mkDerivation {
  pname = "webserver80";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [ base random happstack-server happstack-server-tls process ];
  license = "unknown";
  hydraPlatforms = stdenv.lib.platforms.none;
}
