{
  description = "Convert SSH Ed25519 keys to age keys";

  inputs = {
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    systems.url = "github:ink-splatters/default-systems"; # no x86_64-darwin
  };

  nixConfig = {
    extra-substituters = [
      "https://aarch64-darwin.cachix.org"
    ];
    extra-trusted-public-keys = [
      "aarch64-darwin.cachix.org-1:mEz8A1jcJveehs/ZbZUEjXZ65Aukk9bg2kmb0zL9XDA="
    ];
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} ({lib, ...}: let
      systems = import inputs.systems;
      flakeModules.default = import ./nix/flake-module.nix;
    in {
      inherit systems;
      imports = [
        flake-parts.flakeModules.partitions
        flakeModules.default
      ];

      partitionedAttrs = {
        apps = "dev";
        checks = "dev";
        devShells = "dev";
        formatter = "dev";
      };
      partitions.dev = {
        extraInputsFlake = ./nix/dev;
        module = {
          imports = [./nix/dev];
        };
      };

      perSystem = {config, ...}: {
        options = {
          root = lib.mkOption {
            type = lib.types.path;
            default = ./.;
          };
        };
        config.packages.default = config.packages.ssh-to-age;
      };
      flake = {
        inherit flakeModules;
      };
    });
}
