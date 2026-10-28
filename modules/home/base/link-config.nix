# `link-config SRC DST`: symlink a live-editable config from the repo into $HOME.
# Unlike a plain `ln -sfrT` it never aborts the Home Manager activation:
#   - creates missing parent folders
#   - moves a real file/folder that is in the way to DST.bak-<timestamp>
#   - replaces old (also dangling) symlinks
# Used in home.activation scripts: ${self'.packages.link-config}/bin/link-config <src> <dst>
{
  perSystem =
    { pkgs, ... }:
    {
      packages.link-config = pkgs.writeShellScriptBin "link-config" ''
        src="$1"
        dst="$2"

        if [ ! -e "$src" ]; then
          echo "link-config: source $src does not exist, skipping $dst" >&2
          exit 0
        fi

        mkdir -p "$(dirname "$dst")"

        if [ -e "$dst" ] && [ ! -L "$dst" ]; then
          backup="$dst.bak-$(date +%Y%m%d%H%M%S)"
          echo "link-config: moving existing $dst to $backup" >&2
          mv "$dst" "$backup"
        fi

        ln -sfnr "$src" "$dst"
      '';
    };
}
