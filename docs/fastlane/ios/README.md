To upload a new version to the appstore:

start emulators from command line:
https://medium.com/@abrisad_it/how-to-launch-ios-simulator-and-android-emulator-on-mac-cd198295532e

to create a missing emulator ipad: (adjust ios version and ipad version)
xcrun simctl create "iPad Pro (12.9-inch) (3rd generation)" "com.apple.CoreSimulator.SimDeviceType.iPad-Pro--12-9-inch---3rd-generation-" "com.apple.CoreSimulator.SimRuntime.iOS-14-5"

1. Start all emulators you need screen shots from
    iPhone 12 pro max, iPhone 8 Plus, iPad Pro 12.9 (2nd gen), iPad Pro 12.9 (3rd gen)
2. switch Ipad to horizontal layout

dirs should exist: ios/fastlane/unframed/en-US
from app root: flutter pub run utils:screenshots

to only run the frameit-chrome program:(project home)
flutter pub global run frameit_chrome \
    	--base-dir=ios/fastlane/unframed \
        --frames-dir=ios/fastlane/frames \
        --chrome-binary=/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome \
        --pixel-ratio=2
        --skip_docs

When generated then move from framed/en-US to metadata/screenshots/en-US

Build and upload Manual:
    https://flutter.dev/docs/deployment/ios
certicate access (rediculus!!)    
    https://stackoverflow.com/questions/10204320/mac-os-x-wants-to-use-system-keychain-when-compiling-the-project

Fastlane:
---------
1. increase numbers in ios/Runner/Info.plist:
    CFBundleShortVersionString: major version seen by the user ie: 0.0.13
    CFBundleVersion: seqeuntial nuber within version
2. build flutter: (project home)
    flutter build ios --release --no-codesign
3. compile and sign (in ios dir)
    fastlane gym skip_docs
4. upload: (in ios dir)
    binary only: fastlane upload
    all including meta: fastlane deliver --overwrite_screenshots skip_docs
    just screenshots: fastlane deliver --overwrite_screenshots skip_docs     --skip_binary_upload

login to the appstore console:
create new major version, give reason of update and submit for review
