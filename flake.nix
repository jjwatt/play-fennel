{
  description = "A multi-program Fennel & LOVE2D monorepo environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nix-gl-host.url = "github:numtide/nix-gl-host";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      nix-gl-host,
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

        # Extract the absolute path of the nixglhost binary on Linux systems
        nixglhost-bin = if pkgs.stdenv.isLinux then 
          "${nix-gl-host.packages.${system}.default}/bin/nixglhost" 
        else 
          "";

        # Creates an environment-aware execution wrapper for love
        love-wrapped = if pkgs.stdenv.isLinux then
          pkgs.writeShellScriptBin "love" ''
            if [ -e /etc/NIXOS ]; then
              # Native NixOS execution
              exec ${pkgs.love}/bin/love "$@"
            else
              # Pure non-NixOS Linux execution path (Fedora)
              # Explicitly targets the raw unwrapped store package to prevent looping errors
              exec ${nixglhost-bin} ${pkgs.love}/bin/love "$@"
            fi
          ''
        else
          pkgs.love; # Passes through standard macOS native binary on Darwin
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            luaPackages.fennel
            fennel-ls
            deps-fnl-custom
            lua
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
