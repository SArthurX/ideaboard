{

  description = "Example Haskell development environment for Zero to Nix";
  nixConfig.bash-prompt = "[nix]\\e\[38;5;172mλ \\e\[m";

  # Flake inputs
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  # Flake outputs
  outputs = { self, nixpkgs }:
    let
      allSystems = [
        "x86_64-linux" "aarch64-linux"
        "x86_64-darwin" "aarch64-darwin"
      ];
      forAllSystems = f:
        nixpkgs.lib.genAttrs allSystems
        (system: f {
          system = system;
          pkgs = import nixpkgs { inherit system; };
        });
    in {
      # equal to packages.default or package.<system>.default idrk
      packages = forAllSystems ({ pkgs, ... }: {
        default = {
          postgrest = pkgs.postgrest;
        };
      });
      checks = self.packages;

      devShells = forAllSystems ({ system, pkgs }: {
        default = pkgs.mkShell {
          nativeBuildInputs = [
            self.packages.${system}.default.postgrest
            pkgs.cowsay
            pkgs.docker
            pkgs.docker-compose
            pkgs.jq
            pkgs.postgresql # for psql
          ];
          shellHook = ''
            postgrest --version
          '';
        };
      });
    };
}
