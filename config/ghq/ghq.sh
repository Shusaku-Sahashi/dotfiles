#!/bin/bash

# Create a new repository with ghq and optionally push to GitHub
function new-repo() {
  local repo_name=""
  local create_github=false
  local is_private=false

  # Parse arguments
  while [[ $# -gt 0 ]]; do
    case $1 in
    -g | --github)
      create_github=true
      shift
      ;;
    --private)
      is_private=true
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

  # Validate repository name
  if [[ -z "$repo_name" ]]; then
    echo "Usage: new-repo <repository-name> [-g|--github] [--private]"
    echo ""
    echo "Options:"
    echo "  -g, --github    Create GitHub repository"
    echo "  --private   Create as private repository (default: public)"
    echo ""
    echo "Examples:"
    echo "  new-repo my-project              # Local only"
    echo "  new-repo my-project -g           # Local + GitHub (public)"
    echo "  new-repo my-project -g --private # Local + GitHub (private)"
    return 1
  fi

  # Create local repository with ghq
  echo "Creating local repository: $repo_name"
  ghq create "$repo_name"

  if [[ ! $? ]]; then
    echo "Error: Failed to create local repository"
    return 1
  fi

  local repo_path
  repo_path="$HOME/ghq/github.com/$(git config ghq.user)/$repo_name"

  # Create GitHub repository if requested
  if [[ "$create_github" == true ]]; then
    echo "Creating GitHub repository..."

    local visibility_flag="--public"
    if [[ "$is_private" == true ]]; then
      visibility_flag="--private"
    fi

    cd "$repo_path" || exit
    gh repo create "$repo_name" --source . --push $visibility_flag

    if [[ ! $? ]]; then
      echo "Error: Failed to create GitHub repository"
      return 1
    fi

    echo "GitHub repository created successfully!"
  fi

  cd "$repo_path" || exit
  echo "Repository created at: $repo_path"
}
