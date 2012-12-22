UMedia
======

Music Player

## Version

-  Current: 0.1


## Dependencies

-  sudo apt-get install g++ qt4-dev-tools libdeclarative-multimedia libtag1-dev ffmpeg libavcodec-extra-53 cclive


## Compiling

-  qmake
-  make

If you are using git to update the source code, it is recommended to execute:
-  make clean

Before the "qmake" command after an update.


## Executing

./UMedia [path-to-music-folder]


## Useful Shortcuts

-  Space: Play/Pause
-  Enter: Select song in playlist
-  Up/Down arrow: move selection in playlist
-  Left/Right arrow: move song position
-  Esc: Show/Hide Playlist
-  Tab (With Playlist visible): Expand/Collapse playlist
-  Menu Key: Show/Hide Search
-  Ctrl + Right Arrow: Next Song
-  Ctrl + Left Arrow: Previous Song
-  A: Show/Hide Add Songs
-  Minus (-): Remove selected song from playlist

## Actions with the Mouse

-  Grab the Album Cover and slide it to the center to show the playlist
-  Grab the Album Cover (from the center, when the playlist is visible) and slide it to the left to hide the playlist
-  Grab the Album Cover and slide it to the right to show the playlist expanded
