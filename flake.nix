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

            if [ "$(uname)" = "Linux" ] && [ ! -f /etc/NIXOS ]; then
              # Programmatically locate the active userspace graphics library directories
              # By querying common layout paths on Fedora, Debian, and Ubuntu variants
              HOST_GL_PATHS=""
              for dir in \
                "/usr/lib64" \
                "/usr/lib64/dri" \
                "/usr/lib/$(uname -m)-linux-gnu" \
                "/usr/lib/$(uname -m)-linux-gnu/dri" \
                "/usr/lib/dri"; do
                if [ -d "$dir" ]; then
                  HOST_GL_PATHS="$HOST_GL_PATHS:$dir"
                fi
              done

              export LD_LIBRARY_PATH="$HOST_GL_PATHS:$LD_LIBRARY_PATH"
              
              # Command LÖVE to favor desktop OpenGL initialization over GLES/EGL
              export SDL_RENDER_DRIVER="opengl"
              export SDL_GL_DRIVER="libGL.so.1"
            fi
            echo "Global 'fennel' module is now available to Lua and LOVE2D."
          '';
        };
      }
    );
}
