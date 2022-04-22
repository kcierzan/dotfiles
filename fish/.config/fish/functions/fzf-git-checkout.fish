function fzf-git-checkout --description "Check out a branch"
  set -l branch (git branch --all | grep -v HEAD | fzf | sed "s/.* //" | sed "s#remotes/[^/]*/##")
  git checkout $branch
  commandline --function repaint
end
