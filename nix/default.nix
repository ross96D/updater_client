# to test build, run: `nix-build` from this folder

let
  oldnixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-24.11";
  oldpkgs = import oldnixpkgs { config = {}; overlays = []; };
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-25.05";
  pkgs = import nixpkgs { config = {}; overlays = []; };
in
pkgs.callPackage ./build.nix { flutter319 = oldpkgs.flutter319; }
