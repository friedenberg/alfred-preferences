{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    utils.url = "github:numtide/flake-utils";
    zit = {
      url = "github:friedenberg/zit";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        utils.follows = "utils";
      };
    };
  };

  outputs = { self, nixpkgs, utils, zit }:
    utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = import nixpkgs {
            inherit system;
          };
        in
        with
        pkgs;
        {
          packages.zit = zit.packages.${system}.default;
          packages.php = pkgs.php;
          packages.bash = pkgs.bash;

          devShells.default = pkgs.mkShell {
            buildInputs = with pkgs; [
              zit.packages.${system}.default
              php
              bash
            ];
          };
        }
      );
}



