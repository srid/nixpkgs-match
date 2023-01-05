{
  description = "Update your nixpkgs flake input to the same rev as that of the given flake";
  outputs = { self, ... }: {
    herculesCI.ciSystems = [ "x86_64-linux" "aarch64-darwin" ];
  };
}
