#!/bin/zsh
# set -e

MODULES=("apn" "gamecenter" "inappstore" "photo_picker")
MOD="debug" # <release|debug|release_debug>
VERSION="4.0" # <3.0|4.0>

rm -r bin/*

for MODULE in "${MODULES[@]}"; do	# Compile static libraries
	# ARM64 Device
	scons target=$MOD arch=arm64 plugin=$MODULE version=$VERSION

	# Creating a xcframework
	xcodebuild -create-xcframework -library "./bin/lib$MODULE.arm64-ios.$MOD.a" -output "./bin/$MODULE.$MOD.xcframework"

	# Cleaning
	rm -f ./bin/lib*.a
done

MOD="release"

for MODULE in "${MODULES[@]}"; do	# Compile static libraries
	# ARM64 Device
	scons target=$MOD arch=arm64 plugin=$MODULE version=$VERSION

	# Creating a xcframework
	xcodebuild -create-xcframework -library "./bin/lib$MODULE.arm64-ios.$MOD.a" -output "./bin/$MODULE.$MOD.xcframework"

	# Cleaning
	rm -f ./bin/lib*.a
done
