# Install homebrew
[ ! -f /usr/local/bin/brew ] && ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew tap | grep -q 'universal-ctags' || brew tap universal-ctags/universal-ctags
brew tap | grep -q 'mopidy/mopidy' || brew tap universal-ctags/universal-ctags

pkgs=(
	"universal-ctags --HEAD"
  "chunkwm --with-ffm"
  "ffmpeg --with-rtmpdump --with-openssl --with-libass --with-libbs2b --with-rubberband"
  "libass --without-harfbuzz"
  "mpv --with-vapoursynth --with-libarchive --with-bundle"
	fasd
	fzf
	git
	highlight
	httpie
	hub
	jq
	khd
	mpc
	mutt
	ncmpcpp
	pyenv
	pyenv-virtualenv
	python
	rbenv
	reattach-to-user-namespace
	ripgrep
	ruby
	ssh-copy-id
  ansiweather
  bash
  ccat
  coreutils
  crisidev/chunkwm/chunkwm
  curl
  ddate
  emacs-mac
  exa
  fasd
  ffms2
  findutils
  fontforge
  fzf
  gawk
  gcc
  ghc
  global
  gmime
  gnu-sed
  gnu-tar
  gnu-which
  gnutls
  gpg-agent
  gpgme
  grc
  grep
  gzip
  highlight
  htop
  httpie
  hub
  ispell
  json-c
  koekeishiya/formulae/khd
  less
  markdown
  mopidy
  mopidy-spotify
  mpc
  mpd
  mu
  mvtools
  ncmpcpp
  neofetch
  neomutt/neomutt/neomutt
  neovim
  ngrep
  node
  nvm
  postgresql
  pv
  pyenv-virtualenv
  python3
  rbenv
  readline
  reattach-to-user-namespace
  ripgrep
  rsync
  ruby
  sqlite
  ssh-copy-id
  stow
  the_silver_searcher
  tmux
  vit
  weechat
  xz
  youtube-dl
  zplug
  zsh
)
# Install all brew packages
for pkg in "${pkgs[@]}"
do
	[ ! -d /usr/local/Cellar/$(basename $pkg) ] && brew install $pkg || echo "Already installed: $pkg"
done

[ -d /usr/local/Cellar/$(basename mpv) ] && brew linkapps mpv || echo "mpv not installed!"
