# GrowERP Flutter ERP Admin App.

more info at https://www.growerp.org (be patient, also in flutter, needs to load for the first time....)

- also see the introduction below.

## Online versions.
where you can create your own company, demo data will be provided.
### Web browser version.
- Admin: https://admin.growerp.org

### Android Playstore
- Admin: https://play.google.com/store/apps/details?id=org.growerp.admin

### IOS Appstore:
- Admin: https://apps.apple.com/us/app/growerp-admin-open-source/id1545521755

## To run the system locally.
After installation of [Java 11](https://openjdk.java.net/install/):
  
### Moqui backend: (preferred)
  https://github.com/growerp/growerp-moqui/README.md

### clone and run the WebSocket chat server
  https://github.com/growerp/growerp-chat  

### Flutter app, after [installation of Flutter](https://flutter.dev/docs/get-started/install):
```
git clone https://github.com/growerp/growerp
cd growerp/packages/admin
flutter run
```
create your first company!

## Introduction.
GrowERP Admin Flutter frontend component for Android, IOS and Web using https://flutter.dev This application is build for the stable version of flutter, you can find the installation instructions at: https://flutter.dev/docs/get-started

Although all screens work on IOS/Anderoid/Web devices however a smaller screen will show less information but it is still usable.

It is a simplified frontend however with the ability to still use with, or in addition to the original ERP system screens.
The system is a true multicompany system and can support virtually any ERP backend as long as it has a REST interface.

The system is implemented with https://pub.dev/packages/flutter_bloc state management with the https://bloclibrary.dev documentation, data models, automated integration tests and a separated rest interface for the different systems. 

The system configuration file is in /assets/cfg/app_settings.json. Select OFBiz or Moqui here.

For test purposes we can provide access to Moqui or OFBiz systems in the cloud.

This admin branch is using the core package stored in the same repository in the 'packages' branch.
This package contains all the basic ERP functions, see the [readme](https://github.com/growerp/growerp/blob/packages/core/README.md) file for more info.

Additional ERP systems can be added on request, A REST interface is required.
The implementation time is 40+ hours.

Functions coming up:
More accounting reports

## registering in the app/play stores
Please see the android/fastlane/REDME and ios/fastlane/README files 

## Single company use.

This frontend can be used for a single company, set the company partyId in the assets/cfg frontend dir.
