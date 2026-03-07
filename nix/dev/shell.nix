{
  perSystem = {
    config,
    pkgs,
    ...
  }: let
    inherit (config) pre-commit;
  in {
    devShells.default = pkgs.mkShell {
      packages = with pkgs;
        [
          go
          golangci-lint
        ]
        ++ pre-commit.settings.enabledPackages;

      shellHook = ''
        ${pre-commit.installationScript}
      '';
    };
  };
}
