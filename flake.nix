{
  description = "Update your nixpkgs flake input to the same rev as that of the given flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs@{ self, nixpkgs, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = nixpkgs.lib.systems.flakeExposed;
      perSystem = { self', lib, config, pkgs, ... }: {
        packages =
          let
            # Spit out the nixpkgs rev pinned by the given flake.
            nixpkgs-rev = pkgs.writeShellApplication {
              name = "nixpkgs-rev";
              text = ''
                NIXPKGS=$(nix flake metadata --json "$1" | jq -r .locks.nodes.root.inputs.nixpkgs)
                nix flake metadata --json "$1" | \
                  jq -r .locks.nodes."$NIXPKGS".locked.rev
              '';
            };

            nixpkgs-match = pkgs.writeShellApplication {
              name = "nixpkgs-match";
              text = ''
                REV=$(${lib.getExe nixpkgs-rev} "$1")
                set -x
                nix flake lock --update-input nixpkgs --override-input nixpkgs github:nixos/nixpkgs/"$REV"
              '';
            };
          in
          {
            inherit nixpkgs-match;
            default = nixpkgs-match;
          };
      };

      # CI configuration
      flake.herculesCI.ciSystems = [ "x86_64-linux" "aarch64-darwin" ];
    };
}
