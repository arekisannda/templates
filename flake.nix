{
  description = "Templates";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } (
      { ... }:

      let
        inherit (builtins)
          readDir
          listToAttrs
          attrValues
          mapAttrs
          ;
        mkModule =
          name: type:
          let
            pkgName =
              if type == "regular" && builtins.match ".*\\.nix$" name != null then
                builtins.replaceStrings [ ".nix" ] [ "" ] name
              else
                name;
          in
          {
            name = pkgName;
            value = import (./modules + "/${name}") { };
          };
        flakeModules = (listToAttrs (attrValues (mapAttrs mkModule (readDir ./modules))));
      in
      {
        systems = [
          "x86_64-linux"
          "aarch64-linux"
          "aarch64-darwin"
          "x86_64-darwin"
        ];

        flake = { inherit flakeModules; };
        imports = builtins.attrValues flakeModules;

        flake.templates.devenv = {
          path = ./devenv;
          description = "A simple development environment flake";
        };
      }
    );
}
