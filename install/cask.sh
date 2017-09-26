# Setup cask taps
brew tap | grep -q 'caskroom/cask' || brew tap caskroom/cask
brew tap | grep -q 'caskroom/versions' || brew tap caskroom/versions
brew tap | grep -q 'caskroom/fonts' || brew tap caskroom/fonts

casks=(
  1password
  alfred
  docker
  flux
  font-fantasquesansmono-nerd-font
  font-firacode-nerd-font
  font-hack-nerd-font
  font-inconsolata-nerd-font
  font-iosevka-nerd-font
  font-lekton-nerd-font
  font-monoid-nerd-font
  font-mplus-nerd-font
  font-profont-nerd-font
  font-sharetechmono-nerd-font
  fontforge
  google-chrome
  google-drive
  iterm2-nightly
  moom
  pycharm-ce
  sublime-text
  transmission
  vagrant
  vagrant-manager
  virtualbox
  xquartz
)

# Install all brew casks
for cask in "${casks[@]}"
do
	[ ! -d /usr/local/Caskroom/$(basename $cask) ] && brew cask install $cask || echo "Already installed: $cask"
done
