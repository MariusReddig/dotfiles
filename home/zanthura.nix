{ ... }:
{
  programs.zathura = {
    enable = true;
    extraConfig = ''
      set selection-clipboard clipboard

      map <Button8> navigate next         # mouse button 8 (prev)
      map <Button9> navigate previous     # mouse button 9 (next)
    '';
  };
}
