.PHONY: ios-framework ios-framework-sim _xcframework-headers

RUST_DIR    := rust
IOS_DIR     := ios
GENERATED   := $(IOS_DIR)/generated
XC_HEADERS  := $(IOS_DIR)/xcframework-headers
XCFRAMEWORK := $(IOS_DIR)/MiPTVCore.xcframework

# Prepare the C-only headers directory for the xcframework (no .swift files)
_xcframework-headers:
	mkdir -p $(XC_HEADERS)
	cp $(GENERATED)/ffi_uniffiFFI.h $(XC_HEADERS)/
	printf 'module ffi_uniffiFFI {\n    header "ffi_uniffiFFI.h"\n    export *\n}\n' > $(XC_HEADERS)/module.modulemap

# Build for both device and simulator, then bundle as xcframework
ios-framework:
	cd $(RUST_DIR) && cargo build --target aarch64-apple-ios --release -p ffi-uniffi
	cd $(RUST_DIR) && cargo build --target aarch64-apple-ios-sim --release -p ffi-uniffi
	mkdir -p $(GENERATED)
	cd $(RUST_DIR) && cargo run --bin uniffi-bindgen -- generate \
		--library target/aarch64-apple-ios-sim/release/libffi_uniffi.a \
		--language swift \
		--out-dir ../$(GENERATED) 2>&1
	$(MAKE) _xcframework-headers
	rm -rf $(XCFRAMEWORK)
	xcodebuild -create-xcframework \
		-library $(RUST_DIR)/target/aarch64-apple-ios/release/libffi_uniffi.a \
		-headers $(XC_HEADERS) \
		-library $(RUST_DIR)/target/aarch64-apple-ios-sim/release/libffi_uniffi.a \
		-headers $(XC_HEADERS) \
		-output $(XCFRAMEWORK)

# Simulator-only build (faster for development)
ios-framework-sim:
	cd $(RUST_DIR) && cargo build --target aarch64-apple-ios-sim --release -p ffi-uniffi
	mkdir -p $(GENERATED)
	cd $(RUST_DIR) && cargo run --bin uniffi-bindgen -- generate \
		--library target/aarch64-apple-ios-sim/release/libffi_uniffi.a \
		--language swift \
		--out-dir ../$(GENERATED) 2>&1
	$(MAKE) _xcframework-headers
	rm -rf $(XCFRAMEWORK)
	xcodebuild -create-xcframework \
		-library $(RUST_DIR)/target/aarch64-apple-ios-sim/release/libffi_uniffi.a \
		-headers $(XC_HEADERS) \
		-output $(XCFRAMEWORK)

# ---------------------------------------------------------------------------
# Local iOS dev convenience targets.
# These encapsulate the full pipeline so nobody has to remember the Ruby
# version, the PATH, or the pod-install ordering. See README "Desarrollo iOS".
# ---------------------------------------------------------------------------
APP_DIR     := app
APP_IOS_DIR := $(APP_DIR)/ios
SIMULATOR   ?= iPhone 17
BUNDLE_ID   := org.reactjs.native.example.miptv

# CocoaPods 1.16 only works on Ruby 3.3 (3.4 drops kconv, 4.0 hits a null-byte
# bug). cargo/rustup live in ~/.cargo/bin, off the default PATH. Prepending
# missing dirs is harmless, so exporting this for every recipe is safe.
export PATH := /opt/homebrew/opt/ruby@3.3/bin:$(HOME)/.cargo/bin:$(PATH)
export REACT_NATIVE_NODE_MODULES_DIR := $(abspath $(APP_DIR)/node_modules)

.PHONY: pods metro run-ios-sim run-ios-device

# Install CocoaPods deps. Re-run whenever the xcframework slice set changes.
pods:
	cd $(APP_IOS_DIR) && pod install

# Start the Metro bundler (Debug builds load JS from it at runtime).
metro:
	cd $(APP_DIR) && pnpm start

# Simulator: sim xcframework -> pods -> build -> install -> launch.
# Needs Metro running in another terminal (`make metro`).
run-ios-sim: ios-framework-sim pods
	cd $(APP_IOS_DIR) && xcodebuild -workspace miptv.xcworkspace -scheme miptv \
		-configuration Debug -destination 'platform=iOS Simulator,name=$(SIMULATOR)' \
		-derivedDataPath build build
	xcrun simctl boot "$(SIMULATOR)" 2>/dev/null || true
	open -a Simulator
	xcrun simctl install booted \
		$(APP_IOS_DIR)/build/Build/Products/Debug-iphonesimulator/miptv.app
	xcrun simctl launch booted $(BUNDLE_ID)

# Physical iPhone: full xcframework (device+sim) -> pods, then build in Xcode
# (code signing must be configured there).
run-ios-device: ios-framework pods
	@echo ""
	@echo "xcframework (device+sim) y pods listos."
	@echo "Abre Xcode, selecciona tu iPhone y compila (Cmd+R):"
	@echo "    open $(APP_IOS_DIR)/miptv.xcworkspace"
	@echo "La primera vez, configura tu Team en Signing & Capabilities."
