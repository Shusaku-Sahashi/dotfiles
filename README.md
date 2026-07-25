## dotfiles

```
dotfiles
├── .github/                        # Github Actions
├── README.md
├── .bin.local/                     # Locate local only scripts (put `.local` on file name)
├── .bin/                           # Install scripts
│       ├── setup.ps1               # Windows setup script (Not Work Now)
│       ├── setup.sh                # setup script
├── .config/                        # Configuration files
│       ├── hammerscoop             # Keymap/Automation setting (see: https://www.hammerspoon.org/)
├── Brewfile                        # brew bundle file (see: https://github.com/Homebrew/homebrew-bundle)
```

## How to set up your GitHub account?
If you want to set up your GitHub account, create `.gitconfig.local` file $HOME directory.

## How to set up to open terminal with `opt + i`
Using Raycast keymapping

## Tools
- [Homebrew](https://brew.sh/): Package manager for macOS (GUI apps/casks, and tools that don't fit Nix like `ghcup`)
- [Nix](https://nixos.org/) + [home-manager](https://github.com/nix-community/home-manager): Declarative CLI tool management (see `flake.nix`, `nix/`)
- [Hammerspoon](https://www.hammerspoon.org/): Keymap/Automation setting

### Nix-managed CLI tools

CLI tools (bat, eza, fzf, ripgrep, starship, etc.) are declared in `nix/packages-common.nix` (plus `nix/packages-darwin.nix` / `nix/packages-linux.nix` for platform-specific tools) and installed via home-manager. `.bin/setup.sh` installs Nix and runs `home-manager switch` automatically. To apply changes manually:

```sh
nix run home-manager/master -- switch --flake .#mac --impure   # macOS
nix run home-manager/master -- switch --flake .#wsl --impure   # WSL/Linux
```
