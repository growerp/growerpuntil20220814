# GrowERP Admin App

GrowERP Admin Flutter frontend component for Android, IOS and Web using https://flutter.dev This application is build for the beta version of flutter, you can find the installation instructions at: https://flutter.dev/docs/get-started/web

Although all screens work on IOS/Anderoid/Web devices however a smaller screen will show less information but it is still usable.

It is a simplified frontend however with the ability to still use with, or in addition to the original ERP system screens.
The system is a true multicompany system and can support virtually any ERP backend as long as it has a REST interface.

The system is implemented with https://pub.dev/packages/flutter_bloc state management with the https://bloclibrary.dev documentation, data models, automated tests and a separated rest interface for the different systems. 

The system configuration file is in /assets/cfg/app_settings.json.

There you can configure which system, currently either the Moqui or Apache OFBiz system.

For test purposes we can provide access to Moqui or OFBiz systems inn the cloud.

This admin branch is using the core package stored in the same repository in the 'packages' branch.
This package contains all the basic ERP functions, see the [readme](https://github.com/growerp/growerp/blob/packages/core/README.md) file for more info.

Other branches are under development:
  - Ecommerce : https://github.com/growerp/growerp/tree/ecommerce
  - Hotel : https://github.com/growerp/growerp/tree/hotel

For the backend you need the Moqui or OFBiz ERP framwork system
  with an extra component:
  - Moqui:  https://github.com/growerp/growerp-moqui
  - OFBiz:  https://github.com/growerp/growerp-ofbiz

Additional ERP systems can be added on request, A REST interface is required.
The implementation time is 40+ hours.

Functions coming up:
* Customer & Lead management
* Accounting
* Inventory
* Purchasing.

Screen prints of the current system:
* mobile IPhone
![IOS](screenPrints/mobile/iosMenu.png?raw=true "IOS menu")
![IOS](screenPrints/mobile/iosList.png?raw=true "IOS List")
![IOS](screenPrints/mobile/iosDetail.png?raw=true "IOS Detail")
* mobile android.
![Android](screenPrints/mobile/androidMenu.png?raw=true "Android menu")
![Android](screenPrints/mobile/androidList.png?raw=true "Android list")
![Android](screenPrints/mobile/androidDetail.png?raw=true "Android detail")
* tablet IOS.
![IOS](screenPrints/tablet/iosMenu.png?raw=true "IOS")
![IOS](screenPrints/tablet/iosList.png?raw=true "IOS")
* tablet Android.
![Android](screenPrints/tablet/androidMenu.png?raw=true "Android")
![Android](screenPrints/tablet/androidList.png?raw=true "Android")
* web
![Web](screenPrints/web-browser/webMenu.png?raw=true "Webbrowser menu")
