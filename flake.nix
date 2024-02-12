{
  description = "MakerBot - Replicator 2x Flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.11";
    flake-utils.url = "flake-utils";
  };

  outputs = { nixpkgs, self, flake-utils, ...}:
  flake-utils.lib.eachDefaultSystem (system: 
    let pkgs = import nixpkgs {
      inherit system;
    }; in {
      devShells.default = with pkgs; mkShell {
        packages = [
          gnumake
          python3
          pkgsCross.avr.buildPackages.gcc
          avrdude
        ];
      };
    }
  );
}