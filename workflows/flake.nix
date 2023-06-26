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
          apps.zit = {
            type = "app";
            program = "${zit.packages.${system}.default}/bin/zit";
          };
          packages.default = zit.packages.${system}.default;
          devShells.default =
            mkShell
              {
                buildInputs =
                  [
                    zit.packages.${system}.default
                  ];
              };
        }
      );
}



