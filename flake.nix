{
  description = "Tegami — functional image generation in Haskell";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        ghc = pkgs.haskellPackages.ghcWithPackages (p: with p; [
          bytestring
          JuicyPixels
          parallel
          deepseq
          vector
        ]);
      in {
        devShells.default = pkgs.mkShell {
          packages = [
            ghc
            pkgs.haskell-language-server
          ];
        };
      });
}
