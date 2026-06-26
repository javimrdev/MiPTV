FLUTTER := /Users/jmolina/flutter/bin/flutter
DART    := /Users/jmolina/flutter/bin/dart
APP     := app

.PHONY: setup gen gen-watch run analyze test test-it build-ios build-apk clean help

help:
	@echo "MiPTV Makefile targets:"
	@echo "  make setup      - flutter pub get + pod install (iOS)"
	@echo "  make gen        - run build_runner (Isar/Freezed/JSON codegen)"
	@echo "  make gen-watch  - run build_runner in watch mode"
	@echo "  make run        - flutter run (iOS simulator)"
	@echo "  make analyze    - flutter analyze"
	@echo "  make test       - flutter test (unit + widget)"
	@echo "  make test-it    - flutter test integration_test (real Xtream, optional)"
	@echo "  make build-ios  - flutter build ios --no-codesign"
	@echo "  make build-apk  - flutter build apk (Android, requires SDK)"
	@echo "  make clean      - flutter clean"

setup:
	cd $(APP) && $(FLUTTER) pub get
	cd $(APP)/ios && rbenv exec pod install 2>/dev/null || pod install

gen:
	cd $(APP) && $(DART) run build_runner build

gen-watch:
	cd $(APP) && $(DART) run build_runner watch

run:
	cd $(APP) && $(FLUTTER) run

analyze:
	cd $(APP) && $(FLUTTER) analyze

test:
	cd $(APP) && $(FLUTTER) test

test-it:
	cd $(APP) && $(FLUTTER) test integration_test

build-ios:
	cd $(APP) && $(FLUTTER) build ios --no-codesign

build-apk:
	cd $(APP) && $(FLUTTER) build apk

clean:
	cd $(APP) && $(FLUTTER) clean
