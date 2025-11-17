#!/bin/zsh
# set -e

MODULES=("apn" "camera" "gamecenter" "inappstore" "photo_picker")
MOD="debug" #<release|debug|release_debug>
VERSION="4.0" #<3.0|4.0>

rm -r bin/*

for MODULE in "${MODULES[@]}"; do	# Compile static libraries
	# ARM64 Device
	scons target=$MOD arch=arm64 plugin=$MODULE version=$VERSION
	# ARM64 Simulator
	scons target=$MOD arch=arm64 simulator=yes plugin=$MODULE version=$VERSION

	# # Creating a fat libraries for device and simulator
	# lipo -create \
	# 	"./bin/lib$MODULE.x86_64-simulator.$MOD.a" \
	# 	"./bin/lib$MODULE.arm64-simulator.$MOD.a" \
	# 	-output "./bin/lib$MODULE-simulator.$MOD.a"

	# Creating a xcframework
	xcodebuild -create-xcframework \
	    -library "./bin/lib$MODULE.arm64-ios.$MOD.a" \
	    -library "./bin/lib$MODULE.arm64-simulator.$MOD.a" \
	    -output "./bin/$MODULE.$MOD.xcframework"

	# Cleaning
	rm ./bin/lib*.a
done

MOD="release"

for MODULE in "${MODULES[@]}"; do	# Compile static libraries
	# ARM64 Device
	scons target=$MOD arch=arm64 plugin=$MODULE version=$VERSION
	# ARM64 Simulator
	scons target=$MOD arch=arm64 simulator=yes plugin=$MODULE version=$VERSION

	# # Creating a fat libraries for device and simulator
	# lipo -create \
	# 	"./bin/lib$MODULE.x86_64-simulator.$MOD.a" \
	# 	"./bin/lib$MODULE.arm64-simulator.$MOD.a" \
	# 	-output "./bin/lib$MODULE-simulator.$MOD.a"

	# Creating a xcframework
	xcodebuild -create-xcframework \
	    -library "./bin/lib$MODULE.arm64-ios.$MOD.a" \
	    -library "./bin/lib$MODULE.arm64-simulator.$MOD.a" \
	    -output "./bin/$MODULE.$MOD.xcframework"

	# Cleaning
	rm ./bin/lib*.a
done
