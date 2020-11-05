# GrowERP Admin App

GrowERP Admin Flutter frontend component for Android, IOS and Web using https://flutter.dev
All screens work on all these devices however a smaller screen will show information but is still usable.

It is simplified frontend however with the ability to still use with, or in addition to the original ERP system screens.
The system is a true multicompany system and can support virtually any ERP backend as long as it has a REST interface.

The system is properly implemented with https://pub.dev/packages/flutter_bloc state management.

System configuration file in /assets/cfg/app_settings.json
here you can set either Moqui or Apache OFBiz system

For test purposes we can provide access to Moqui or OFBiz systems.

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
17. Central configuration file

And applications:
* Company & User management
* Catalog and product management

For the backend you need the Moqui or OFBiz ERP system
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
