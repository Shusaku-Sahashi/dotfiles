# CLI tools managed by Nix/home-manager, migrated off Homebrew.
# Platform-specific extras live in packages-darwin.nix / packages-linux.nix.
{ pkgs }:

with pkgs; [
  bat
  eza
  fzf
  gawk
  gh
  ghq
  htop
  jq
  neovim
  ripgrep
  starship
  stylua
  tmux
  tree
  exiftool
  pdfcpu
  mise
]
