# Linux-only CLI tools. macOS ships pbcopy/pbpaste instead of xclip.
{ pkgs }:

with pkgs; [ xclip ]
