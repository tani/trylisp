{
  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = inputs@{nixpkgs, flake-parts, ...}:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = nixpkgs.lib.platforms.all;
      perSystem = { pkgs, ... }:
      {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [ sbcl esbuild pnpm nodejs ];
        };
      };
    };
}
