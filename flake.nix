{
  description = "A multi-program Fennel & LOVE2D monorepo environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
        {
          devShells.default = pkgs.mkShell {
            buildInputs = with pkgs; [
              luaPackages.fennel
              fennel-ls
              lua
              love
            ];

            shellHook = ''
            FENNEL_SHARE="${pkgs.luaPackages.fennel}/share/lua/${pkgs.lua.luaversion}"
            export LUA_PATH="$FENNEL_SHARE/?.lua;$FENNEL_SHARE/?/init.lua;./?.lua;;"

            echo "Global 'fennel' module is now available to Lua and LOVE2D."
            '';
          };
        });
}
