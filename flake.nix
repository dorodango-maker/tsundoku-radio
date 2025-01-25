{
  description = "Description for the project";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    devenv.url = "github:cachix/devenv";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.devenv.flakeModule
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
          # self',
          # inputs',
          pkgs,
          # system,
          ...
        }:
        {
          devenv.shells.default = {
            packages =
              let
                mdformatAndPlugins = with pkgs.python312Packages; [
                  mdformat
                  mdformat-frontmatter
                  mdformat-tables
                ];
              in
              with pkgs;
              [
                hugo
                markdownlint-cli
              ]
              ++ mdformatAndPlugins;
            scripts = {
              list =
                let
                  inherit (pkgs) lib;
                in
                {
                  exec = ''
                    echo
                    echo 🦾 Helper scripts you can run to make your development richer:
                    echo 🦾
                    ${pkgs.gnused}/bin/sed -e 's| |••|g' -e 's|=| |' <<EOF \
                    | ${pkgs.util-linuxMinimal}/bin/column -t | ${pkgs.gnused}/bin/sed -e 's|^|🦾 |' -e 's|••| |g'
                    ${lib.generators.toKeyValue { } (
                      lib.mapAttrs (name: value: value.description) config.devenv.shells.default.scripts
                    )}
                    EOF
                    echo
                  '';
                  description = "devenvで定義したのscripts一覧";
                };
              hugo-server = {
                exec = ''
                  cd $REPO_ROOT
                  hugo server --buildFuture
                '';
                description = "hugo-blog執筆用: 未来に公開する記事を表示する";
              };
              hugo-new-content = {
                exec = ''
                  cd $REPO_ROOT
                  hugo new content content/post/$1/index.md
                  git checkout -b $1
                '';
                description = "hugo-blog執筆用: 新規の記事作成";
              };
            };
            enterShell = ''
              hugo version
              list
            '';
          };
        };
    };
}
