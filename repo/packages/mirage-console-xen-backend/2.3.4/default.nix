world:
let
    fetchurl = pkgs.fetchurl;
    inputs = lib.filter (dep: dep != true && dep != null)
    ([  ] ++ (lib.attrValues opamDeps));
    lib = pkgs.lib;
    opam2nix = world.opam2nix;
    opamDeps = 
    {
      io-page-xen = opamSelection.io-page-xen;
      jbuilder = opamSelection.jbuilder;
      lwt = opamSelection.lwt;
      mirage-console-lwt = opamSelection.mirage-console-lwt;
      mirage-console-xen-proto = opamSelection.mirage-console-xen-proto;
      ocaml = opamSelection.ocaml;
      ocamlfind = opamSelection.ocamlfind or null;
      shared-memory-ring-lwt = opamSelection.shared-memory-ring-lwt;
      xen-evtchn = opamSelection.xen-evtchn;
      xen-gnt = opamSelection.xen-gnt;
      xenstore = opamSelection.xenstore;
    };
    opamSelection = world.opamSelection;
    pkgs = world.pkgs;
in
pkgs.stdenv.mkDerivation 
{
  buildInputs = inputs;
  buildPhase = "${opam2nix}/bin/opam2nix invoke build";
  configurePhase = "true";
  installPhase = "${opam2nix}/bin/opam2nix invoke install";
  name = "mirage-console-xen-backend-2.3.4";
  opamEnv = builtins.toJSON 
  {
    deps = opamDeps;
    files = null;
    name = "mirage-console-xen-backend";
    ocaml-version = world.ocamlVersion;
    spec = ./opam;
  };
  passthru = 
  {
    opamSelection = opamSelection;
  };
  propagatedBuildInputs = inputs;
  src = fetchurl 
  {
    sha256 = "1gyw99m1qcq8llviwimg67yfpj4xa9gjhcsjx4vafx1x00a7j55h";
    url = "https://github.com/mirage/mirage-console/releases/download/v2.3.4/mirage-console-2.3.4.tbz";
  };
  unpackCmd = "tar -xf \"$curSrc\"";
}

