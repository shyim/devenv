{
  description = "devenv - Developer Environments";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
  inputs.flake-compat = {
    url = "github:edolstra/flake-compat";
    flake = false;
  };
  inputs.nix.url = "github:domenkozar/nix/relaxed-flakes";

  outputs = { self, nixpkgs, pre-commit-hooks, nix, ... }:
    let
      systems = [ "x86_64-linux" "i686-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
      forAllSystems = f: builtins.listToAttrs (map (name: { inherit name; value = f name; }) systems);
      mkPackage = pkgs: import ./src/devenv.nix { inherit pkgs nix; };
      mkDocOptions = pkgs:
        let
          eval = pkgs.lib.evalModules {
            modules = [ ./src/modules/top-level.nix ];
            specialArgs = { inherit pre-commit-hooks pkgs; };
          };
          options = pkgs.nixosOptionsDoc {
            options = builtins.removeAttrs eval.options [ "_module" ];
          };
        in
        options.optionsCommonMark;
    in
    {
      packages = forAllSystems (system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {
          devenv = mkPackage pkgs;
          devenv-docs-options = mkDocOptions pkgs;
        }
      );

      defaultPackage = forAllSystems (system: self.packages.${system}.devenv);
    };
}
