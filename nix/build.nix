# to include in your system, add to your packages dependencies:
#   (pkgs.callPackage ./nix/build.nix { })
# if using nix 25.05+, flutter319 is not there, so you need to manually import nix 24:
#   oldnixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-24.11";
#   oldpkgs = import oldnixpkgs  { config = {}; overlays = []; };
# and add it like this:
#   (pkgs.callPackage ./nix/build.nix { flutter319 = oldpkgs.flutter319; })

{
  flutter319,
  fetchFromGitHub,
  pkgs
} :
flutter319.buildFlutterApplication rec {
  pname = "updater_client";
  version = "0.0.1";

  src = fetchFromGitHub {
    # https://github.com/ross96D/wayxec
    owner = "ross96D";
    repo = "updater_client";
    rev = "34592ecd333ff6a32d83c524c97047811547ad70";
    sha256 = "sha256-1w/kRcz29xK81pH65ACHkIB+HdIKUDmk0zg8giw+hGs=";
  };

  # buildInputs = with pkgs; [
  #
  # ];

  autoPubspecLock = src + "/pubspec.lock";

  #buildPhase = ''
  #  runHook preBuild
  #  mkdir -p build/flutter_assets/fonts
  #  flutter build linux apps/firmware_updater/lib/main.dart
  #  runHook postBuild
  #'';
}
