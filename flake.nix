{
  description = "Simple shells called baseshells";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    let
      version = "1.1.0";
      repo = "https://github.com/TureBentzin/baseshell";
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ ];
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];

      perSystem =
        { pkgs, ... }:
        let
          shell = pkgs.fish;

          baseShellLicense = pkgs.stdenv.mkDerivation {
            pname = "baseshell-license";
            inherit version;

            src = ./.;

            installPhase = ''
                  mkdir -p $out/bin

                  cp $src/LICENSE.md $out/LICENSE.md

                  cat > $out/bin/baseshell-license << EOF
              #!/usr/bin/env bash
              echo "Baseshell version ${version} is licensed under the MIT-License:"
              echo
              cat "$out/LICENSE.md"
              echo
              echo "The source is available at: ${repo}"
              EOF

              chmod +x $out/bin/baseshell-license
            '';
          };
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
            baseShellLicense
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
            ++ [
              shell
              baseShellLicense
            ]
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
        meta = {
          description = "Very simple devshell environments built around the fish shell.";
          homepage = repo;
          license = "MIT";
          maintainers = [
            {
              name = "Ture Bentzin";
              github = "TureBentzin";
            }
          ];
        };
      };
    };
}
