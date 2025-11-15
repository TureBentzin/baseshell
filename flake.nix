{
  description = "Description for the project";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    let
      version = "1.0.0";
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
      ];
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      perSystem =
        {
          config,
          self',
          inputs',
          pkgs,
          system,
          ...
        }:
        let

          shell = pkgs.fish;

          editors = with pkgs; [
            nano
            helix
            vim
          ];

          git = pkgs.gitFull;

          programs = with pkgs; [
            htop
            btop
            direnv
          ];

          tools = with pkgs; [
            tree
            openssh
          ];

          default-packages = [
            shell
            git
          ]
          ++ editors
          ++ programs
          ++ tools;

          minimal-packages =
            with pkgs;
            [
              helix
              htop
              git
              direnv
              tree
            ]
            ++ [ shell ]
            ++ tools;

          mkShell =
            name: packages:
            pkgs.mkShell {
              name = "baseshell-${name}";
              inherit packages version;
              shellHook = ''
                echo "Thank you for using baseshell! (https://github.com/TureBentzin/baseshell.git)"
              '';
            };

        in
        {
          devShells = {
            default = mkShell "default" default-packages;
            minimal = mkShell "minimal" minimal-packages;
          };
        };
      flake = {
      };
    };
}
