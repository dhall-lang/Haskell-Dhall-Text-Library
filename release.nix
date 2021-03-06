let
  fetchNixpkgs = import ./nix/fetchNixpkgs.nix;

  nixpkgs = fetchNixpkgs {
    rev = "1d4de0d552ae9aa66a5b8dee5fb0650a4372d148";

    sha256 = "09qx58dp1kbj7cpzp8ahbqfbbab1frb12sh1qng87rybcaz0dz01";

    outputSha256 = "0xpqc1fhkvvv5dv1zmas2j1q27mi7j7dgyjcdh82mlgl1q63i660";
  };

  config = {
    packageOverrides = pkgs: {
      haskellPackages = pkgs.haskellPackages.override {
        overrides = haskellPackagesNew: haskellPackagesOld: {
          dhall =
            pkgs.haskell.lib.dontCheck
              (haskellPackagesNew.callPackage ./nix/dhall.nix { });

          megaparsec = haskellPackagesNew.callPackage ./nix/megaparsec.nix { };

          repline = haskellPackagesNew.callPackage ./nix/repline.nix { };

          dhall-text =
            pkgs.haskell.lib.failOnAllWarnings
              (pkgs.haskell.lib.justStaticExecutables
                (haskellPackagesNew.callPackage ./nix/dhall-text.nix { })
              );
        };
      };
    };
  };

  pkgs =
    import nixpkgs { inherit config; };

in
  { inherit (pkgs.haskellPackages) dhall-text; }
