# Setup cask taps
brew tap | grep -q 'caskroom/cask' || brew tap caskroom/cask
brew tap | grep -q 'caskroom/versions' || brew tap caskroom/versions
brew tap | grep -q 'caskroom/fonts' || brew tap caskroom/fonts

casks=(
  1password
  alfred
  boostnote
  docker
  firefoxnightly
  flux
  font-fira-sans
  font-merriweather
  fontforge
  google-drive
  handbrake
  iterm2-nightly
  karabiner-elements
  moom
  transmission
  vagrant
  vagrant-manager
  virtualbox
  visual-studio-code
  xquartz
)

# Install all brew casks
for cask in "${casks[@]}"
do
	[ ! -d /usr/local/Caskroom/$(basename $cask) ] && brew cask install $cask || echo "Already installed: $cask"
done
