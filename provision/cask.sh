# Setup cask taps
brew tap | grep -q 'caskroom/cask' || brew tap caskroom/cask
brew tap | grep -q 'caskroom/versions' || brew tap caskroom/versions
brew tap | grep -q 'caskroom/fonts' || brew tap caskroom/fonts

casks=(
	alfred
	dash
	docker
	1password
	sublime-text
	flux
	transmission
	ubersicht
	google-chrome
	google-drive
	virtualbox
	vagrant
	iterm2-nightly
	font-firacode-nerd-font
	font-iosevka-nerd-font
	font-hack-nerd-font
)

# Install all brew casks
for cask in "${casks[@]}"
do
	[ ! -d /usr/local/Caskroom/$(basename $cask) ] && brew cask install $cask || echo "Already installed: $cask"
done
