{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

  };
  outputs = { self, nixpkgs, flake-utils}:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          
          pkgs = nixpkgs.legacyPackages.${system};
          inherit (pkgs) lib stdenv;
          # 👇 new! note that it refers to the path ./rust-toolchain.toml
        in
        with pkgs;
        {
          devShells.default = mkShell {
            # 👇 we can just use `rustToolchain` here:

            NIX_LD_LIBRARY_PATH = lib.makeLibraryPath  [
            pkgs.gcc-unwrapped # Provides libstdc++ v6
            pkgs.xorg.libX11
            pkgs.xorg.libXext
            pkgs.xorg.libXrender
            pkgs.xorg.libXrandr
            pkgs.xorg.libxcb
            pkgs.xorg.libXinerama
            pkgs.alsa-lib
            pkgs.jack2
            pkgs.libGL
            pkgs.librsvg
            ];
          };
          NIX_LD = lib.fileContents "${stdenv.cc}/nix-support/dynamic-linker";
        }
      );
}

