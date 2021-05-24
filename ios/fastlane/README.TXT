To upload a new version to the appstore:

1. Start emulator you need screen shots, (app root dir)
    iPhone 11, iPhone 8, iPad Pro 11, iPad Pro 12.9
2. switch Ipad to horizontal layout

from app root:
flutter pub run utils:screenshots

to only run the frameit-chrome program:
flutter pub global run frameit_chrome \
    	--base-dir=ios/fastlane/screenshots/unframed \
        --frames-dir=ios/fastlane/frames \
        --chrome-binary=/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome \
        --pixel-ratio=2



When generated then move from framed/en-US to iOS/screenshots/en-US