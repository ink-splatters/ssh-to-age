{
  perSystem = {pkgs, ...}: {
    formatter = pkgs.writeShellScriptBin "fmt-all" ''
      ${pkgs.alejandra}/bin/alejandra .

      echo "Formatting Go files..."
      ${pkgs.go}/bin/go fmt ./...
    '';
  };
}
