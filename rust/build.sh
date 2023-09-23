#!/bin/bash

# # Step 1: Build the Rust static libraries for different architectures
# cargo build --release --target=aarch64-apple-ios
# cargo build --release --target=x86_64-apple-ios
# cargo build --release --target=aarch64-apple-ios-sim

echo "🏗  Building libpact_ffi.a for x86_64 iOS Simulator"
echo "cargo build --target=x86_64-apple-ios --release"
cargo build --target=x86_64-apple-ios --release

echo "🏗  Building libpact_ffi.a for arm64 iOS Simulator"
cargo +nightly build -Z build-std --target aarch64-apple-ios-sim --release

echo "🏗  Building libpact_ffi.a for arm64 iOS device"
echo "cargo build --target=aarch64-apple-ios --release"
cargo build --target=aarch64-apple-ios --release

echo "🏗  Building libpact_ffi.a for x86_64 Darwin"
echo "cargo build --target=x86_64-apple-darwin --release"
cargo build --target=x86_64-apple-darwin --release

echo "🏗  Building libpact_ffi.a for arm64 Darwin"
echo "cargo build --target=aarch64-apple-darwin --release"
cargo build --target=aarch64-apple-darwin --release

# Step 2: Use cbindgen to generate C headers
mkdir -p headers
cbindgen --crate clvm --output headers/clvm.h

# Step 3: Create the XCFramework
xcodebuild -create-xcframework \
-library target/aarch64-apple-ios/release/libclvm.a -headers headers/ \
-library target/x86_64-apple-ios/release/libclvm.a -headers headers/ \
-library target/aarch64-apple-ios-sim/release/libclvm.a -headers headers/ \
-output Clibclvm.xcframework

# -library target/aarch64-apple-ios-sim/release/libclvm.a \

echo "Clibclvm.xcframework created successfully!"
