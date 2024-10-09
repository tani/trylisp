{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = inputs:
    inputs.flake-utils.lib.eachDefaultSystem (system:
      {
        devShell = pkgs.mkShell {
          buildInputs = [
            pkgs.sbcl
          ];
        };
      }
    );
}