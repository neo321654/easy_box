import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Easy Box App', () {
    late FlutterDriver driver;

    const longTimeout = Timeout(Duration(minutes: 2));

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      driver.close();
    });

    Future<void> resetApp(FlutterDriver driver) async {
      try {
        await driver.waitFor(find.byValueKey('logout_button'), timeout: const Duration(seconds: 5));
        await driver.tap(find.byValueKey('logout_button'));
        await driver.waitFor(find.byValueKey('login_email_field'));
      } catch (e) {
        // Ignore, we are probably on the login page.
      }
    }

    setUp(() async {
      await resetApp(driver);
    });

    Future<void> login(FlutterDriver driver) async {
      final emailField = find.byValueKey('login_email_field');
      final passwordField = find.byValueKey('login_password_field');
      await driver.tap(emailField);
      await driver.enterText('admin@example.com');
      await driver.tap(passwordField);
      await driver.enterText('password');
      final loginButton = find.byValueKey('login_button');
      await driver.tap(loginButton);
      await driver.waitFor(find.byValueKey('home_menu_inventory'), timeout: const Duration(seconds: 10));
    }

    group('Authentication', () {
      test('successful login and logout', () async {
        await login(driver);

        final logoutButton = find.byValueKey('logout_button');
        await driver.tap(logoutButton);

        await driver.waitFor(find.byValueKey('login_email_field'));
      }, timeout: longTimeout);

      test('failed login', () async {
        final emailField = find.byValueKey('login_email_field');
        final passwordField = find.byValueKey('login_password_field');

        await driver.tap(emailField);
        await driver.enterText('wrong@example.com');
        await driver.tap(passwordField);
        await driver.enterText('wrongpassword');

        final loginButton = find.byValueKey('login_button');
        await driver.tap(loginButton);

        await driver.waitFor(find.byValueKey('login_email_field'));
      }, timeout: longTimeout);
    });

    group('Inventory Management', () {
      test('view and scroll product list', () async {
        await login(driver);
        final inventoryMenuButton = find.byValueKey('home_menu_inventory');
        await driver.tap(inventoryMenuButton);
        await driver.waitFor(find.byValueKey('inventory_product_list'));

        final productList = find.byValueKey('inventory_product_list');
        await driver.scroll(productList, 0, -500, const Duration(milliseconds: 500));
        await Future.delayed(const Duration(seconds: 1));
        await driver.scroll(productList, 0, 500, const Duration(milliseconds: 500));

        await driver.tap(find.pageBack());
      }, timeout: longTimeout);

      test('search for a product', () async {
        await login(driver);
        final inventoryMenuButton = find.byValueKey('home_menu_inventory');
        await driver.tap(inventoryMenuButton);
        await driver.waitFor(find.byValueKey('inventory_product_list'));

        final searchField = find.byValueKey('inventory_search_field');
        await driver.tap(searchField);
        await driver.enterText('SKU-TS-RED-L');
        await driver.waitFor(find.text('Red T-Shirt, Size L'));

        await driver.tap(find.pageBack());
      }, timeout: longTimeout);

      test('create a new product', () async {
        await login(driver);
        final inventoryMenuButton = find.byValueKey('home_menu_inventory');
        await driver.tap(inventoryMenuButton);
        await driver.waitFor(find.byValueKey('inventory_product_list'));

        final addProductFab = find.byValueKey('add_product_fab');
        await driver.tap(addProductFab);

        final nameField = find.byValueKey('add_product_name_field');
        final skuField = find.byValueKey('add_product_sku_field');
        final locationField = find.byValueKey('add_product_location_field');
        final saveButton = find.byValueKey('add_product_save_button');

        final newSku = 'NEW-SKU-${DateTime.now().millisecondsSinceEpoch}';

        await driver.tap(nameField);
        await driver.enterText('New Product');
        await driver.tap(skuField);
        await driver.enterText(newSku);
        await driver.tap(locationField);
        await driver.enterText('A1-01-03');
        await driver.tap(saveButton);

        await Future.delayed(const Duration(seconds: 10));

        await driver.waitFor(find.text('New Product'));
        await driver.waitFor(find.text(newSku));

        await driver.tap(find.pageBack());
      }, timeout: longTimeout);

      test('product image is displayed in the list', () async {
        await login(driver);
        final inventoryMenuButton = find.byValueKey('home_menu_inventory');
        await driver.tap(inventoryMenuButton);
        await driver.waitFor(find.byValueKey('inventory_product_list'));

        final productListItem = find.byValueKey('product_list_item_SKU-TS-RED-L');

        await driver.waitForAbsent(find.descendant(
          of: productListItem,
          matching: find.byValueKey('broken_image_icon'),
        ));

        await driver.tap(find.pageBack());
      }, timeout: longTimeout);
    });

    group('Stock Receiving', () {
      test('add stock to existing product', () async {
        await login(driver);
        final receivingMenuButton = find.byValueKey('home_menu_receiving');
        await driver.tap(receivingMenuButton);
        await driver.waitFor(find.byValueKey('receiving_sku_field'));

        final skuField = find.byValueKey('receiving_sku_field');
        final quantityField = find.byValueKey('receiving_quantity_field');
        final addStockButton = find.byValueKey('receiving_add_stock_button');

        await driver.tap(skuField);
        await driver.enterText('SKU-TS-RED-L');
        await driver.tap(quantityField);
        await driver.enterText('10');
        await driver.tap(addStockButton);

        await driver.waitFor(find.text('Stock added successfully for SKU: SKU-TS-RED-L'));

        await driver.tap(find.pageBack());
      }, timeout: longTimeout);
    });

    group('Order Picking', () {
      test('pick an order', () async {
        await login(driver);
        final pickingMenuButton = find.byValueKey('home_menu_picking');
        await driver.tap(pickingMenuButton);
        await driver.waitFor(find.byValueKey('order_list'));

        await driver.tap(find.text('ORD-001 - John Doe'));
        await driver.waitFor(find.byValueKey('picking_scan_barcode_button'));

        await driver.tap(find.text('Red T-Shirt, Size L'));
        await Future.delayed(const Duration(seconds: 1));

        await driver.tap(find.text('Green Hoodie, Size M'));
        await Future.delayed(const Duration(seconds: 1));

        final completeButton = find.byValueKey('picking_complete_button');
        await driver.tap(completeButton);

        await driver.tap(find.text('Complete Picking'));

        await driver.waitFor(find.byValueKey('order_list'));
      }, timeout: longTimeout);
    });
  });
}