function rlm --description='Update default branch from remote and rebase the current branch onto it'
  set upstream (git remote)
  set current_branch (git branch --show-current)
  set default_branch (git symbolic-ref "refs/remotes/$upstream/HEAD" | sed "s@^refs/remotes/$upstream/@@")

  git stash push -m "rlm_stash"

  if test $current_branch = $default_branch
    git pull $upstream $current_branch
  else
    git fetch $upstream "$default_branch:$default_branch"
    git rebase $default_branch
  end

  git stash apply stash^{/rlm_stash}
end
