# GrowERP Admin App

GrowERP Admin Flutter frontend component for Android, IOS and Web using https://flutter.dev This application is build for the beta version of flutter, you can find the installation instructions at: https://flutter.dev/docs/get-started/web

All screens work on all IOS/Anderoid/Web devices however a smaller screen will show less information but it is still usable.

It is a simplified frontend however with the ability to still use with, or in addition to the original ERP system screens.
The system is a true multicompany system and can support virtually any ERP backend as long as it has a REST interface.

The system is properly implemented with https://pub.dev/packages/flutter_bloc state management, data models, automated tests and a separated rest interface for the different systems.

The system configuration file is in /assets/cfg/app_settings.json.
There you can configure which system, currently either the Moqui or Apache OFBiz system.

For test purposes we can provide access to Moqui or OFBiz systems inn the cloud.

This admin branch contains all basic functions:

1. login
2. logout
3. registration of new company and admin user.
4. registration new admin, employee existing company
5. forgot password
6. change pasword
7. communication with the server containing Apache OFBiz or Moqui.org.
8. tests of most functions. >50%
9. switch between companies: ecommerce.
10. 'About' form describing the App.
11. routing between forms
12. state management using flutter_bloc
13. master of ALL models
14. Fully multicompany.
15. Image up/download for IOS,Android and the web.
16. Interface to either OFBiz or Moqui ERP system.
17. Central configuration file.
18. All major entities have a picture upload.

And applications:
* Company & User management
* Catalog and product management

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
* Order management
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
