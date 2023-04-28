{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs, ... }:
  let
    system = "aarch64-darwin";
    pkgs = import nixpkgs { system = system; };
    lib = pkgs.lib;
  in
  {
    devShells.${system}.default = pkgs.mkShell {
      packages = with pkgs; [
        ocaml
        ocamlPackages.utop
      ];
    };
  };
}
