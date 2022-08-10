# Welcome to flutter open source GrowERP.

GrowERP is an open source multi platform ERP application you can try right now!

We have latest test version at [admin.growerp.org](https://admin.growerp.org)
Data at this site will be refreshed regularly.

We have now started a Beta production version:
- Web:     https://admin.growerp.com
- Android: https://play.google.com/store/apps/details?id=org.growerp.admin
- IOS:     https://apps.apple.com/us/app/growerp-admin-open-source/id1545521755

When the application is loaded, create a new company, select demo data and look around!

If you like this initiative, please give a star to the project.
 
Documentation available at https://www.growerp.com

We also created a first vertical app for Hotel owners which will be released later. 
- Web:     https://hotel.growerp.org
- Android: https://play.google.com/store/apps/details?id=org.growerp.hotel
- IOS:     https://apps.apple.com/us/app/growerp-admin-open-source/id1531267095

### Install flutter app locally
git clone https://github.com/growerp/growerp.git
cd growerp/packages/core
flutter pub get & flutter pub run build_runner build
cd ../admin

### Prepare for backend
OR:  install backend according: https://github.com/growerp/growerp-moqui.git

OR: use our test backend:  
change file packages/admin/assets/cfg/app_settings.json:
- from:   "databaseUrlDebug": "http://localhost:8080",
- to:     "databaseUrlDebug": "https://test.growerp.org",  

- from:   "chatUrlDebug":  "ws://localhost:8081",
- to:     "chatUrlDebug": "wss://chat.growerp.org",  
  
start emulator or use browser and start app: flutter run

### Some phone screen shots:
<div style="text-align: center">
    <table>
        <tr>
            <td style="text-align: center">
                    <img src="https://raw.githubusercontent.com/growerp/growerp/master/packages/admin/android/fastlane/metadata/images/phoneScreenshots/Pixel_4_API_31-dashboard.png" width="200">
            </td>            
            <td style="text-align: center">
                    <img src="https://raw.githubusercontent.com/growerp/growerp/master/packages/admin/android/fastlane/metadata/images/phoneScreenshots/Pixel_4_API_31-account.png" width="200">
            </td>
            <td style="text-align: center">
                    <img src="https://raw.githubusercontent.com/growerp/growerp/master/packages/admin/android/fastlane/metadata/images/phoneScreenshots/Pixel_4_API_31-catalog.png" width="200">
            </td>
        </tr>
        <tr>
            <td style="text-align: center">
                    <img src="https://raw.githubusercontent.com/growerp/growerp/master/packages/admin/android/fastlane/metadata/images/phoneScreenshots/Pixel_4_API_31-ledgers.png" width="200">
            </td>            
            <td style="text-align: center">
                    <img src="https://raw.githubusercontent.com/growerp/growerp/master/packages/admin/android/fastlane/metadata/images/phoneScreenshots/Pixel_4_API_31-orders.png" width="200">
            </td>
            <td style="text-align: center">
                    <img src="https://raw.githubusercontent.com/growerp/growerp/master/packages/admin/android/fastlane/metadata/images/phoneScreenshots/Pixel_4_API_31-website.png" width="200">
            </td>
        </tr>
    </table>
</div>

### Some web/tablet screen shots:
<div style="text-align: center">
    <table>
        <tr>
            <td style="text-align: center">
                    <img src="https://raw.githubusercontent.com/growerp/growerp/master/packages/admin/android/fastlane/metadata/images/teninchScreenshots/Nexus_10_API_30-dashboard.png" width="600">
            </td>            
        </tr>
        <tr>
            <td style="text-align: center">
                    <img src="https://raw.githubusercontent.com/growerp/growerp/master/packages/admin/android/fastlane/metadata/images/teninchScreenshots/Nexus_10_API_30-account.png" width="600">
            </td>            
        </tr>
        <tr>
            <td style="text-align: center">
                    <img src="https://raw.githubusercontent.com/growerp/growerp/master/packages/admin/android/fastlane/metadata/images/teninchScreenshots/Nexus_10_API_30-catalog.png" width="600">
            </td>            
        </tr>
        <tr>
            <td style="text-align: center">
                    <img src="https://raw.githubusercontent.com/growerp/growerp/master/packages/admin/android/fastlane/metadata/images/teninchScreenshots/Nexus_10_API_30-ledgers.png" width="600">
            </td>            
        </tr>
        <tr>
            <td style="text-align: center">
                    <img src="https://raw.githubusercontent.com/growerp/growerp/master/packages/admin/android/fastlane/metadata/images/teninchScreenshots/Nexus_10_API_30-website.png" width="600">
            </td>
        </tr>
    </table>
</div>

### The generated business website:
<div style="text-align: center">
    <table>
        <tr>
            <td style="text-align: center">
                    <img src="https://raw.githubusercontent.com/growerp/growerp/master/docs/_media/htmlWebsite.png" width="600">
            </td>            
        </tr>
    </table>
</div>
