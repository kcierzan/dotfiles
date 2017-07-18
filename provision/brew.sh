# Install homebrew
[ ! -f /usr/local/bin/brew ] && ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew tap | grep -q 'universal-ctags' || brew tap universal-ctags/universal-ctags
brew tap | grep -q 'mopidy/mopidy' || brew tap universal-ctags/universal-ctags

pkgs=(
  neovim
  "chunkwm --with-ffm"
	pyenv
	pyenv-virtualenv
  coreutils
  gnu-sed
  gzip
  grep
  less
	ruby
	mpc
	git
	colordiff
	fasd
  rsync
	jq
	ripgrep
	ssh-copy-id
	httpie
	fzf
	highlight
	"universal-ctags --HEAD"
	reattach-to-user-namespace
	mutt
	hub
	tig
	lua
  tmux
	python
  neofetch
	python3
	khd
	ncmpcpp
	rbenv
  mopidy
  mopidy-spotify
  "libass --without-harfbuzz"
  "ffmpeg --with-rtmpdump --with-openssl --with-libass --with-libbs2b --with-rubberband"
  "mpv --with-vapoursynth --with-libarchive --with-bundle"
  mvtools
  ffms2
  subliminal
  youtube-dl
  zplug
  zsh
  exa
)

# Install all brew packages
for pkg in "${pkgs[@]}"
do
	[ ! -d /usr/local/Cellar/$(basename $pkg) ] && brew install $pkg || echo "Already installed: $pkg"
done

[ -d /usr/local/Cellar/$(basename mpv) ] && brew linkapps mpv || echo "mpv not installed!"
