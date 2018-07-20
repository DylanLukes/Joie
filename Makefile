.PHONY: clean xcodeproj


xcodeproj:
	swift package generate-xcodeproj --enable-code-coverage --xcconfig-overrides Configs/*.xcconfig
