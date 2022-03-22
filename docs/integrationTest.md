# Integration test

For this system we created integration tests only. We consider unit test too high maintenance. These integration tests are 'kind of' end user readable.

Initial data is stored in packages/core/lib/domains/common/integration_test/data.dart

When data is created by the tests the resulting ID with the initial data is stored using the 'shared_preferences' package via the 'persist_functions.dart' file under the name 'test'.


## the tests are divided into three levels of detail.

### Example top level
The top level integration tests are stored in the top level packages because menu structure can different for every top level app like 'admin', 'hotel' etc.  
Test file example: packages/admin/integration_test/growerp_test.dart

[filename](https://raw.githubusercontent.com/growerp/growerp/master/packages/admin/integration_test/growerp_test.dart ':include :type=code :fragment=createCompany')

### Example intermediate level.
the intermediate level tests are stored in the packages/core/lib/domain directories. This level will store the immediate results in shared preferences.  
Test file example: 
```
    await CommonTest.tapByKey(tester, 'newCompButton');
    await CommonTest.enterText(tester, 'firstName', admin.firstName!);
    await CommonTest.enterText(tester, 'lastName', admin.lastName!);
    await CommonTest.tapByKey(tester, 'registerButton');
```
example lowest level in file core/domains/common/integration_test/common_test.dart
```
  static Future<void> tapByKey(WidgetTester tester, String key,
      {int seconds = 1}) async {
    await tester.tap(find.byKey(Key(key)).last);
    await tester.pumpAndSettle(Duration(seconds: seconds));
  }

```