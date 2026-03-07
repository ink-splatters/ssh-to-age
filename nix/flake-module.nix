{lib, ...}: {
  perSystem = {
    config,
    pkgs,
    ...
  }: let
    inherit (config) root;
    fromRoot = path: root + "/${path}";
    fileContents = name: lib.fileContents (fromRoot name);
  in {
    packages.ssh-to-age = let
      version = fileContents "VERSION.txt";
      vendorHash = fileContents "/go.mod.sri";
    in
      pkgs.buildGoModule {
        pname = "ssh-to-age";
        inherit version vendorHash;

        src = lib.fileset.toSource {
          inherit root;
          fileset = lib.fileset.unions (builtins.map fromRoot [
            "go.mod"
            "go.sum"
            "cmd"
            "bech32"
            "convert.go"
          ]);
        };

        subPackages = ["cmd/ssh-to-age"];

        ldflags = ["-s" "-w" "-X main.version=${version}"];

        checkPhase = ''
          runHook preCheck
          go test ./...
          runHook postCheck
        '';

        shellHook = ''
          unset GOFLAGS
        '';

        doCheck = true;

        meta = with lib; {
          description = "Convert ssh private keys in ed25519 format to age keys";
          homepage = "https://github.com/ink-splatters/ssh-to-age";
          license = licenses.mit;
          maintainers = with maintainers; [mic92];
        };
      };
  };
}
