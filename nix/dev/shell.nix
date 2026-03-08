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
          go_1_26
          golangci-lint
        ]
        ++ pre-commit.settings.enabledPackages;

      shellHook = ''
        ${pre-commit.installationScript}
      '';
    };
  };
}
