To upload a new version to the appstore:

to create a missing emulator ipad: (adjust ios version and ipad version)
xcrun simctl create "iPad Pro (12.9-inch) (3rd generation)" "com.apple.CoreSimulator.SimDeviceType.iPad-Pro--12-9-inch---3rd-generation-" "com.apple.CoreSimulator.SimRuntime.iOS-14-5"

1. Start emulator you need screen shots, (app root dir)
    iPhone 12 pro max, iPhone 8 Plus, iPad Pro 12.9 (2nd gen), iPad Pro 12.9 (3rd gen)
2. switch Ipad to horizontal layout

from app root:
flutter pub run utils:screenshots

to only run the frameit-chrome program:(project home)
flutter pub global run frameit_chrome \
    	--base-dir=ios/fastlane/unframed \
        --frames-dir=ios/fastlane/frames \
        --chrome-binary=/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome \
        --pixel-ratio=2



When generated then move from framed/en-US to iOS/screenshots/en-US