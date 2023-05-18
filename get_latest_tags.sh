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
    
    # Get the latest git tag
    latest_tag=$(git describe --tags --abbrev=0 2>/dev/null)
    
    # If there are no tags, skip to the next directory
    if [ -z "$latest_tag" ]; then
      cd ..
      continue
    fi
    
    # Output the repository name and latest tag
    echo "$repo_name - $latest_tag"
    
    # Change back to the original directory
    cd ..
  fi
done

