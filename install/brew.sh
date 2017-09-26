# Install homebrew
[ ! -f /usr/local/bin/brew ] && ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew tap | grep -q 'universal-ctags' || brew tap universal-ctags/universal-ctags
brew tap | grep -q 'mopidy/mopidy' || brew tap universal-ctags/universal-ctags

pkgs=(
 "ffmpeg --with-rtmpdump --with-openssl --with-libass --with-libbs2b --with-rubberband"
 "libass --without-harfbuzz"
 "mpv --with-vapoursynth --with-libarchive --with-bundle"
 "universal-ctags --HEAD"
 ansiweather
 bash
 ccat
 coreutils
 curl
 ddate
 exa
 fasd
 ffms2
 findutils
 fontforge
 fzf
 gawk
 gcc
 ghc
 git
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
 jq
 khd
 koekeishiya/formulae/khd
 less
 markdown
 mopidy
 mopidy-spotify
 mpc
 mpd
 mvtools
 ncmpcpp
 neovim
 ngrep
 node
 nvm
 postgresql
 pv
 pyenv
 pyenv-virtualenv
 python
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
