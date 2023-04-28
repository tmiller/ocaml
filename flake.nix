{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs, ... }:
  let
    system = "aarch64-darwin";
    pkgs = import nixpkgs { system = system; };
    lib = pkgs.lib;
  in
  {
    packages.${system} = {
      default = self.packages.${system}.hello;

      hello = with pkgs; stdenv.mkDerivation {
        name = "hello";
        version = "0.0.0";
        src = ./.;
        inherit ocaml;
        buildPhase = ''
          export PATH="$ocaml/bin:$PATH"
          mkdir -p $out/bin
          ocamlopt -o $out/bin/hello data.mli data.ml main.ml
        '';
      };
    };
    app.${system}.default = {
      description = "A simple hello world application";
      type = "service";
      start = "${self.packages.${system}.hello}/bin/hello";
    };
    devShells.${system}.default = pkgs.mkShell {
      packages = with pkgs; [
        ocaml
        opam
        ocamlPackages.utop
      ];
    };
  };
}
