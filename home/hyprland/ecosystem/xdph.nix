{ pkgs, username, host, ... }: {
  home.file.".config/hypr/xdph.conf".text = ''
    screencopy {
        max_fps = 60
        cursor_mode = 2
    }  '';
}
