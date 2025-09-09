import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('EasyBox App', () {
    late FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      driver.close();
    });

    test('login and navigate to home', () async {
      // Wait for the login page to load
      await driver.waitFor(find.byValueKey('login_email_field'));

      // Enter email
      await driver.enterText('admin@example.com');

      // Enter password
      await driver.tap(find.byValueKey('login_password_field'));
      await driver.enterText('password');

      // Tap login button
      await driver.tap(find.byValueKey('login_button'));

      // Wait for the home page to load (e.g., by checking for the logout button)
      await driver.waitFor(find.byValueKey('logout_button'));

      // Take a screenshot (this might still fail due to DTD issues)
      // await driver.screenshot(); // Uncomment if you want to try taking a screenshot

      // Verify that we are on the home page (optional, can check text or other elements)
      expect(await driver.getText(find.text('Welcome, Admin User')), 'Welcome, Admin User');
    });
  });
}
