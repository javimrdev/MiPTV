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
