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

    # 1. Place the clean, original deps script into libexec
    mkdir -p $out/bin $out/libexec
    cp deps $out/libexec/deps

    # 2. Dynamically find the path to the true standalone fennel CLI script.
    # We look for the file named 'fennel' that lives down inside the rock tree structures.
    fennelCli=$(find "${pkgs.luaPackages.fennel}" -type f -path "*/fennel-1.6.1-1-rocks/*/bin/fennel" | head -n 1)

    # 3. Write a clean shell wrapper into bin/deps.
    # We feed the raw script file right into the vanilla lua interpreter binary.
    # This keeps the 'arg' table perfectly clean and free of Luarocks strings!
    cat << EOF > $out/bin/deps
#!/bin/sh
exec "${pkgs.lua}/bin/lua" "$fennelCli" "$out/libexec/deps" "\$@"
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
            deps-fnl-custom
            lua
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
