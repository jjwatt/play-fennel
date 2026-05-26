{
  description = "A multi-program Fennel & LOVE2D monorepo environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nixgl.url = "github:nix-community/nixGL";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      nixgl,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        overlays = if system == "x86_64-linux" then [ nixgl.overlay ] else [ ];
        pkgs = import nixpkgs { inherit system overlays; };
        deps-fnl-custom = pkgs.deps-fnl.overrideAttrs (oldAttrs: rec {
          installPhase = ''
            runHook preInstall

            mkdir -p $out/bin $out/libexec
            cp deps $out/libexec/deps

            fennelCli=$(find "${pkgs.luaPackages.fennel}" -type f -path "*/bin/fennel" | head -n 1)

            cat << EOF > $out/bin/deps
              #!/bin/sh
              exec "${pkgs.luaPackages.lua}/bin/lua" "$fennelCli" "$out/libexec/deps" "\$@"
            EOF

            chmod +x $out/bin/deps

            runHook postInstall
          '';
        });

        love-wrapped = if system == "x86_64-linux" then
          pkgs.writeShellScriptBin "love" ''
            if [ -e /etc/NIXOS ]; then
                exec ${pkgs.love}/bin/love "$@"
            else
                # Non-NixOS x86_64 Linux
                exec ${pkgs.nixgl.nixGLMesa}/bin/nixGLMesa ${pkgs.love}/bin/love "$@"
            fi
            ''
        else
          pkgs.love;
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            luaPackages.fennel
            fennel-ls
            fnlfmt
            deps-fnl-custom
            luaPackages.luarocks
            luaPackages.lua
            love-wrapped
          ];

          shellHook = ''
            FENNEL_SHARE="${pkgs.luaPackages.fennel}/share/lua/${pkgs.lua.luaversion}"
            DEPS_SHARE="${deps-fnl-custom}/share/lua/${pkgs.lua.luaversion}"
            export LUA_PATH="$FENNEL_SHARE/?.lua;$FENNEL_SHARE/?/init.lua;$DEPS_SHARE/?.lua;./?.lua;;"
            export PATH="${deps-fnl-custom}/bin:$PATH"

            echo "Global 'fennel' module is now available to Lua and LOVE2D."
          '';
        };
      }
    );
}
