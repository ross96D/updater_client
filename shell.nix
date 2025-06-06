# for developing, open a nix shell from this folder:
#   nix-shell
# and you can just use `flutter run` and other commands normally

{
  pkgs ? import <nixpkgs> {},
} :
let
  oldnixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-24.11";
  oldpkgs = import oldnixpkgs  { config = {}; overlays = []; };
in
pkgs.mkShell {
  buildInputs = with pkgs; [
    oldpkgs.flutter319
  ];
}
