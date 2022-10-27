#!/bin/sh

webpack --config webpack.config.js  # Create build.js

# Build binaries
rm dist/binaries/*
pkg build.js -o dist/binaries/how2 --targets=node16-linux,node16-macos,node16-macos-arm64 #,node16-win-x64
pkg build.js -o dist/binaries/how2 --targets=node16-win-x64

cd dist/binaries

# Sign Apple Silicon binary
codesign -vvvvv -s MMJ44P3H29 how2-macos-arm64
chmod +x how2-macos-arm64

# Compress
tar cvzf how2-linux-x64.tar.gz    how2-linux-x64
tar cvzf how2-macos-x64.tar.gz    how2-macos-x64
tar cvzf how2-macos-arm64.tar.gz  how2-macos-arm64
zip -r how2-win.zip               how2.exe
mv *.tar.gz ../release
mv *.zip ../release

# Build .deb
cd ../deb
./build-deb.sh
mv how2.deb ../release

# Print hashes for brew
cd ../release
sha256sum how2-macos-x64.tar.gz
sha256sum how2-macos-arm64.tar.gz

ls -lah
open ../release

# brew audit --strict --new-formula --online <formula>
