# Install homebrew
[ ! -f /usr/local/bin/brew ] && ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew tap | grep -q 'universal-ctags' || brew tap universal-ctags/universal-ctags
brew tap | grep -q 'mopidy/mopidy' || brew tap universal-ctags/universal-ctags

pkgs=(
  ansiweather
  "chunkwm --with-ffm"
  coreutils
  ddate
  exa
	fasd
  "ffmpeg --with-rtmpdump --with-openssl --with-libass --with-libbs2b --with-rubberband"
  ffms2
  fontforge
	fzf
	git
	highlight
	hub
  gnu-sed
  grep
  gzip
	httpie
	jq
	khd
  less
  "libass --without-harfbuzz"
  mopidy
  mopidy-spotify
	mpc
  "mpv --with-vapoursynth --with-libarchive --with-bundle"
	mutt
  mvtools
  neofetch
  neomutt
  neovim
	ncmpcpp
  nvm
  postgresql
	pyenv
	pyenv-virtualenv
	python
	python3
	rbenv
  readline
	reattach-to-user-namespace
	ripgrep
	ruby
  rsync
  sqlite
	ssh-copy-id
  stow
  subliminal
  task
  tmux
	"universal-ctags --HEAD"
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
