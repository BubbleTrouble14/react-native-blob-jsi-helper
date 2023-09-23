#!/bin/bash

WORKSPACE=$PWD

echo "🏗  Building libclvm.a for x86_64 iOS Simulator"
cargo build --target=x86_64-apple-ios --release

echo "🏗  Building libclvm.a for arm64 iOS Simulator"
cargo +nightly build -Z build-std --target aarch64-apple-ios-sim --release

echo "🏗  Building libclvm.a for arm64 iOS device"
cargo build --target=aarch64-apple-ios --release

echo "🏗  Building libclvm.a for x86_64 Darwin"
cargo build --target=x86_64-apple-darwin --release

echo "🏗  Building libclvm.a for arm64 Darwin"
cargo build --target=aarch64-apple-darwin --release

echo "✅  libclvm.a binaries built"

#######################
# Generate Headers    #
#######################

# Use cbindgen to generate the header file
echo "🏗  Generating header file using cbindgen..."
mkdir -p headers
cbindgen --crate clvm --output headers/clvm.h
echo "👍  Header file generated."

#######################
# Pact Mock Server    #
#######################

# Copy the compiled binaries into the current directory
echo "🏗  Copying binaries to ${WORKSPACE}"

# Create directories
mkdir -p $WORKSPACE/Resources/iphoneos
mkdir -p $WORKSPACE/Resources/iphonesimulator
mkdir -p $WORKSPACE/Resources/macos

# Copy binary for an iOS device
echo "🚚  Copying to iphoneos directory..."
cp target/aarch64-apple-ios/release/libclvm.a $WORKSPACE/Resources/iphoneos/
echo "👍  Copied to iphoneos directory."

echo "🚚  Creating a fat binary for iOS Simulator..."
lipo -create \
	target/x86_64-apple-ios/release/libclvm.a \
	target/aarch64-apple-ios-sim/release/libclvm.a \
	-output $WORKSPACE/Resources/iphonesimulator/libclvm.a
echo "👍  Created binary for iphonesimulator."

# Create a fat darwin binary for macos
echo "🚚  Copying to macos directory..."
lipo -create \
	target/x86_64-apple-darwin/release/libclvm.a \
	target/aarch64-apple-darwin/release/libclvm.a \
	-output $WORKSPACE/Resources/macos/libclvm.a
echo "👍  Created binary for macos."

echo "🏗  Building XCFramework..."
xcodebuild -create-xcframework \
-library $WORKSPACE/Resources/iphoneos/libclvm.a -headers headers/ \
-library $WORKSPACE/Resources/iphonesimulator/libclvm.a -headers headers/ \
-library $WORKSPACE/Resources/macos/libclvm.a -headers headers/ \
-output Clibclvm.xcframework

#######################
# Cleanup             #
#######################

echo "🎉  All done!"
