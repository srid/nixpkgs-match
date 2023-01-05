# nixpkgs-match

Update your nixpkgs flake input to the same rev as that of the given flake

## Usage

``` sh
nix run github:srid/nixpkgs-match -- github:srid/haskell-template
```

This will update your local `flake.lock`'s "nixpkgs" input up until the revision of the "nixpkgs" input of the given flake (github:srid/haskell-template).

## Motivation

Instead of updating the unstable nixpkgs willy-nilly, it may be better to do the same in a canonical place, and then update other repos to the same matching nixpkgs.
