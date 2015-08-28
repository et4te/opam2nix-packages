let
    buildWithOverride = override:
    { fetchurl, opam2nix, opamSelection, pkgs, stdenv
    }:
    let
        inputs = lib.filter (dep: dep != true && dep != null)
        ([  ]++(lib.attrValues opamDeps));
        lib = pkgs.lib;
        opamDeps = 
        {
          async = opamSelection.async or null;
          async_ssl = opamSelection.async_ssl or null;
          cstruct = opamSelection.cstruct;
          ipaddr = opamSelection.ipaddr;
          lwt = opamSelection.lwt or null;
          mirage-dns = opamSelection.mirage-dns or null;
          mirage-types-lwt = opamSelection.mirage-types-lwt or null;
          ocaml = opamSelection.ocaml;
          ocamlfind = opamSelection.ocamlfind;
          sexplib = opamSelection.sexplib;
          ssl = opamSelection.ssl or null;
          stringext = opamSelection.stringext;
          tls = opamSelection.tls or null;
          uri = opamSelection.uri;
          vchan = opamSelection.vchan or null;
        };
    in
    stdenv.mkDerivation (override 
    {
      buildInputs = inputs;
      buildPhase = "${opam2nix}/bin/opam2nix invoke build";
      configurePhase = "true";
      createFindlibDestdir = true;
      installPhase = "${opam2nix}/bin/opam2nix invoke install";
      name = "conduit-0.8.6";
      opamEnv = builtins.toJSON 
      {
        deps = opamDeps;
        files = null;
        name = "conduit";
        spec = ./opam;
      };
      passthru = 
      {
        opamSelection = opamSelection;
      };
      propagatedBuildInputs = inputs;
      src = fetchurl 
      {
        sha256 = "1hvw6zbf9k318bm0skxr3a1srimszp43475gyzaj13lqgngnxvhc";
        url = "https://github.com/mirage/ocaml-conduit/archive/v0.8.6.tar.gz";
      };
    })
    
    ;
    identity = x: x;
    wrap = buildWithOverride:
    {
      impl = buildWithOverride identity;
      withOverride = override:
      wrap (additionalOverride:
      buildWithOverride (attrs:
      additionalOverride (override attrs)
      )
      )
      ;
    }
    ;
in
wrap buildWithOverride
