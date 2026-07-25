{ pkgs, ... }:

{
  home.stateVersion = "24.11";

  home.packages =
    import ./packages-common.nix { inherit pkgs; }
    ++ (if pkgs.stdenv.isDarwin
        then import ./packages-darwin.nix { inherit pkgs; }
        else import ./packages-linux.nix { inherit pkgs; });

  # Package management only: dotfile symlinking stays with .bin/setup.sh.
  programs.home-manager.enable = true;
}
