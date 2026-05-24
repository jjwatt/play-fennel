{
  description = "A multi-program Fennel & LOVE2D monorepo environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
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
            love
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
