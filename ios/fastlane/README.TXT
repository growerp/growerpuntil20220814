To upload a new version to the appstore:

start emulators from command line:
https://medium.com/@abrisad_it/how-to-launch-ios-simulator-and-android-emulator-on-mac-cd198295532e

to create a missing emulator ipad: (adjust ios version and ipad version)
xcrun simctl create "iPad Pro (12.9-inch) (3rd generation)" "com.apple.CoreSimulator.SimDeviceType.iPad-Pro--12-9-inch---3rd-generation-" "com.apple.CoreSimulator.SimRuntime.iOS-14-5"

1. Start emulator you need screen shots from, (app root dir)
    iPhone 12 pro max, iPhone 8 Plus, iPad Pro 12.9 (2nd gen), iPad Pro 12.9 (3rd gen)
2. switch Ipad to horizontal layout

enable enableFlutterDriverExtension(); in lib/main.dart
dirs should exist: ios/fastlane/unframed/en-US
from app root:
flutter pub run utils:screenshots

to only run the frameit-chrome program:(project home)
flutter pub global run frameit_chrome \
    	--base-dir=ios/fastlane/unframed \
        --frames-dir=ios/fastlane/frames \
        --chrome-binary=/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome \
        --pixel-ratio=2

When generated then move from framed/en-US to screenshots/en-US

Build and upload Manual:
    https://flutter.dev/docs/deployment/ios

hotel is manual: 

certicate access (rediculus!!)    
    https://stackoverflow.com/questions/10204320/mac-os-x-wants-to-use-system-keychain-when-compiling-the-project

Fastlane:
build flutter: (project home)
increase number in ios/Runner/Info.plist AND version name X.X.X
flutter build ios --release --no-codesign

compile and sign (in ios dir)
fastlane gym

upload: (in ios dir)
fastlane deliver

