#!/bin/bash

# Find all directories within the current directory
directories=$(find . -type d)

# Iterate over each directory
for directory in $directories; do
  # Check if the directory is a git repository
  if [ -d "$directory/.git" ]; then
    # Get the repo name from the directory name
    repo_name=$(basename "$directory")

    # Change to the repository directory
    cd "$directory"

    # Perform a git fetch to get the latest information (hide output)
    git fetch --tags >/dev/null 2>&1

    # Save the current branch name
    current_branch=$(git symbolic-ref --short HEAD)

    # Check if there are any changes in the current branch
    if ! git diff-index --quiet HEAD --; then
      # Stash the changes
      git stash save --include-untracked >/dev/null 2>&1
    fi

    # Switch to the master branch
    git checkout master >/dev/null 2>&1

    # Get the latest git tag
    latest_tag=$(git describe --tags --abbrev=0 2>/dev/null)

    # If there are no tags, skip to the next directory
    if [ -z "$latest_tag" ]; then
      # Switch back to the original branch
      git checkout "$current_branch" >/dev/null 2>&1
      cd ..
      continue
    fi

    # Output the repository name and latest tag
    echo "$repo_name - $latest_tag"

    # Switch back to the original branch
    git checkout "$current_branch" >/dev/null 2>&1

    # Apply the stashed changes
    git stash apply --quiet

    # Change back to the original directory
    cd ..
  fi
done

