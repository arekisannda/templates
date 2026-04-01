{ ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      apps.devenv-setup = {
        type = "app";
        meta = {
          description = "Setup development environment";
        };

        program = pkgs.writeShellScriptBin "devenv-setup" ''
          [ -f .envrc ] && echo "Development environment configured." && exit 0

          cat <<EOF > .envrc
          use flake
          EOF

          direnv allow
        '';
      };
    };
}
