{
  description = "Ideaborad development enviroment";
  #nixConfig.bash-prompt = "[nix]\\e\[38;5;172mλ \\e\[m";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
  flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs { inherit system; };
    in
    {
      devShell = pkgs.mkShell {
        packages = with pkgs; [
          cowsay
          podman
          podman-compose
          jq

          rustc 
          cargo 
          trunk
        ];

        shellHook = 
        ''
          podman-compose up -d

          alias pcu='podman-compose up -d'
          alias pcd='podman-compose down'
        '';
      };
    }
  );
}
