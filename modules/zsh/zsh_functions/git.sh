#!/bin/bash

# pull the protected branch and cleanup
gcmld() {
  if git branch -a | grep -E 'remotes/origin/master' > /dev/null; then
    git checkout master 
  else
    git checkout main
  fi

  git pull
  comm -12 <(git branch | sed "s/ *//g") <(git remote prune origin --dry-run | sed "s/^.*origin\///g") | xargs -I'{}' git branch -D {}
}
