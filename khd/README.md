# khd installation on MacOS

As of `khd` version 3.0, manipulating khd from the fish shell is problematic. Symptoms include
lagging behavior and general unresponsiveness.

To fix this, we must bypass the `brew services` method of launching `khd` and instead use `launchctl` in combination with `khd.plist`.

1. Copy `khd.plist` to `~/Library/LaunchAgents/`
2. Run `launchctl -w load ~/Library/LaunchAgents/khd.plist`
