{
  description = "Templates";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      flake.templates.devenv = {
        path = ./devenv;
        description = "A simple development environment flake";
      };

      flake.modules.flake = {
        devenv-setup = import ./modules/devenv-setup.nix;
      };
    };
}
