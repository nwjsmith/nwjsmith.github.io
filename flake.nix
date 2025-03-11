{
  description = "My website";
  inputs = {
    flake-schemas.url = "https://flakehub.com/f/DeterminateSystems/flake-schemas/*";
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1.*";
  };
  outputs = {
    self,
    flake-schemas,
    nixpkgs,
  }: let
    supportedSystems = ["x86_64-linux" "aarch64-darwin" "aarch64-linux"];
    forEachSupportedSystem = f:
      nixpkgs.lib.genAttrs supportedSystems (system:
        f {
          pkgs = import nixpkgs {inherit system;};
        });
  in {
    schemas = flake-schemas.schemas;
    formatter = forEachSupportedSystem ({pkgs}: pkgs.alejandra);
    devShells = forEachSupportedSystem ({pkgs}: {
      default = pkgs.mkShell {
        packages = with pkgs; [
          ruby_3_4
        ];
      };
    });
  };
}
