#!/bin/bash

# pull the protected branch and cleanup
gcmld() {
  if git branch -a | grep -E 'remotes/origin/master' > /dev/null; then
    git checkout master
  else
    git checkout main
  fi

  git pull --rebase --autostash

  # prune deleted remote branches
  git remote prune origin

  # prune local branches that have been merged
  if git branch -a | grep -E 'remotes/origin/master' > /dev/null; then
    branches=$(git branch --merged master | grep -v '^[ *]*master$')
    if [ "$branches" != "" ]; then xargs git branch -d "$branches"; fi
  else
    branches=$(git branch --merged main | grep -v '^[ *]*main$')
    if [ "$branches" != "" ]; then xargs git branch -d "$branches"; fi
  fi
}
