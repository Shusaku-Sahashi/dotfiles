#!/bin/bash

# Create a new repository with ghq and optionally push to GitHub
alias new-repo="_new-repo-dispatch"

function _new-repo-dispatch() {
  local subcommand="$1"
  shift

  case "$subcommand" in
  create) _new-repo-create "$@" ;;
  move) _new-repo-move "$@" ;;
  *)
    echo "Usage: new-repo <subcommand> <repository-name> [options]"
    echo ""
    echo "Subcommands:"
    echo "  create <name>           Create GitHub repo (private) + local"
    echo "  create <name> --public  Create GitHub repo (public) + local"
    echo "  create <name> --local   Local only (stored in ghq/_private/)"
    echo "  move   <name>           Move from ghq/_private/ to ghq/github.com/<user>/"
    echo "  move   <name> --public  Move + create GitHub repo (public)"
    return 1
    ;;
  esac
}

function _new-repo-create() {
  local repo_name=""
  local is_public=false
  local is_local=false

  while [[ $# -gt 0 ]]; do
    case $1 in
    --public)
      is_public=true
      shift
      ;;
    --local)
      is_local=true
      shift
      ;;
    *)
      if [[ -z "$repo_name" ]]; then
        repo_name="$1"
      else
        echo "Error: Unknown argument '$1'"
        return 1
      fi
      shift
      ;;
    esac
  done

  if [[ -z "$repo_name" ]]; then
    echo "Usage: new-repo create <repository-name> [--public] [--local]"
    return 1
  fi

  local ghq_user
  ghq_user="$(git config ghq.user)"
  if [[ -z "$ghq_user" ]]; then
    echo "Error: ghq.user is not set. Run: git config --global ghq.user <your-github-username>"
    return 1
  fi

  local private_path="$HOME/ghq/_private/$repo_name"
  local github_path="$HOME/ghq/github.com/$ghq_user/$repo_name"

  if [[ "$is_local" == true ]]; then
    if [[ -d "$private_path" ]]; then
      echo "Error: Repository already exists at $private_path"
      return 1
    fi

    echo "Creating local repository: $repo_name"
    mkdir -p "$private_path"
    git init "$private_path"

    if [[ $? -ne 0 ]]; then
      echo "Error: Failed to create local repository"
      return 1
    fi

    cd "$private_path" || return 1
    echo "Repository created at: $private_path"
    return 0
  fi

  # GitHub creation (private by default)
  if [[ -d "$github_path" ]]; then
    echo "Error: Repository already exists at $github_path"
    return 1
  fi

  echo "Creating local repository: $repo_name"
  ghq create "$repo_name"

  if [[ $? -ne 0 ]]; then
    echo "Error: Failed to create local repository"
    return 1
  fi

  local visibility_flag="--private"
  if [[ "$is_public" == true ]]; then
    visibility_flag="--public"
  fi

  cd "$github_path" || return 1
  echo "Creating GitHub repository ($visibility_flag)..."
  gh repo create "$repo_name" --source . --push $visibility_flag

  if [[ $? -ne 0 ]]; then
    echo "Error: Failed to create GitHub repository"
    return 1
  fi

  echo "Repository created at: $github_path"
}

function _new-repo-move() {
  local repo_name=""
  local is_public=false

  while [[ $# -gt 0 ]]; do
    case $1 in
    --public)
      is_public=true
      shift
      ;;
    *)
      if [[ -z "$repo_name" ]]; then
        repo_name="$1"
      else
        echo "Error: Unknown argument '$1'"
        return 1
      fi
      shift
      ;;
    esac
  done

  if [[ -z "$repo_name" ]]; then
    echo "Usage: new-repo move <repository-name> [--public]"
    return 1
  fi

  local ghq_user
  ghq_user="$(git config ghq.user)"
  if [[ -z "$ghq_user" ]]; then
    echo "Error: ghq.user is not set. Run: git config --global ghq.user <your-github-username>"
    return 1
  fi

  local private_path="$HOME/ghq/_private/$repo_name"
  local github_path="$HOME/ghq/github.com/$ghq_user/$repo_name"

  if [[ ! -d "$private_path" ]]; then
    echo "Error: Repository not found at $private_path"
    return 1
  fi

  if [[ -d "$github_path" ]]; then
    echo "Error: Repository already exists at $github_path"
    return 1
  fi

  echo "Moving repository: $private_path -> $github_path"
  mkdir -p "$HOME/ghq/github.com/$ghq_user"
  mv "$private_path" "$github_path"

  if [[ $? -ne 0 ]]; then
    echo "Error: Failed to move repository"
    return 1
  fi

  echo "Moved to: $github_path"

  if [[ "$is_public" == true ]]; then
    cd "$github_path" || return 1
    echo "Creating GitHub repository (--public)..."
    gh repo create "$repo_name" --source . --push --public

    if [[ $? -ne 0 ]]; then
      echo "Error: Failed to create GitHub repository"
      return 1
    fi

    echo "GitHub repository created successfully!"
  fi

  cd "$github_path" || return 1
}
