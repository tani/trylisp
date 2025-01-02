{
  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = inputs@{nixpkgs, flake-parts, ...}:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = nixpkgs.lib.platforms.all;
      perSystem = { pkgs, ... }: let
        jscl_build = pkgs.writeShellScriptBin "jscl_build" ''
          [ -d jscl ] || ${pkgs.git}/bin/git clone https://github.com/jscl-project/jscl
          ${pkgs.sbcl}/bin/sbcl --load 'jscl/jscl.lisp' --eval '(jscl:bootstrap)' --eval '(quit)'
          ${pkgs.git}/bin/git -C jscl archive HEAD -o ../dist/jscl.tar.gz
        '';
        app_build = pkgs.writeShellScriptBin "app_build" ''
          set -eo pipefail
          ${pkgs.pnpm}/bin/pnpm install
          ${pkgs.esbuild}/bin/esbuild src/*.ts --bundle --external:readline --outdir=dist --sourcemap --minify --format=esm
        '';
        httpd = pkgs.writeShellScriptBin "server" ''
          set -eo pipefail
          ${pkgs.python3}/bin/python3 -m http.server "$@"
        '';
      in
      {
        apps = {
          jscl_build = {
            type = "app";
            program = jscl_build;
          };
          app_build = {
            type = "app";
            program = app_build;
          };
          httpd = {
            type = "app";
            program = httpd;
          };
        };
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [ sbcl esbuild pnpm nodejs ];
        };
      };
    };
}
