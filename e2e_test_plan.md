# End-to-End (E2E) Testing Plan for Easy Box App

## 1. Goal

The goal of this E2E testing plan is to create a suite of automated tests that simulate real user scenarios to ensure the application's key functionalities are working correctly from end to end.

## 2. Technology

We will use the `flutter_driver` extension, which is the official E2E testing framework for Flutter. This allows us to write tests in Dart and control the application running on a real device or emulator.

## 3. Test Scenarios

The following user flows will be covered in our E2E tests:

### 3.1. Authentication
- **SCN-AUTH-01:** Successful login with valid credentials.
- **SCN-AUTH-02:** Failed login with invalid credentials.
- **SCN-AUTH-03:** Successful logout.

### 3.2. Inventory Management
- **SCN-INV-01:** View and scroll through the product list.
- **SCN-INV-02:** Search for a specific product by SKU.
- **SCN-INV-03:** Create a new product.
- **SCN-INV-04:** Edit an existing product's details.

### 3.3. Stock Receiving
- **SCN-REC-01:** Add stock to an existing product.

### 3.4. Order Picking
- **SCN-ORD-01:** Open an order from the list.
- **SCN-ORD-02:** Pick an item by scanning its barcode.
- **SCN-ORD-03:** Complete the picking process for an order.

## 4. Implementation Steps

1.  **Setup Dependencies:**
    - Add `flutter_driver` and `test` to `dev_dependencies` in `pubspec.yaml`.
    - Run `flutter pub get`.

2.  **Create Test Files:**
    - Create a `test_driver` directory in the project root.
    - Inside `test_driver`, create `app.dart`. This file will launch the main application with `flutter_driver` extension enabled.
    - Inside `test_driver`, create `app_test.dart`. This file will contain the test scripts.

3.  **Write Test Scripts:**
    - Implement each test scenario in `app_test.dart` using the `flutter_driver` API.
    - Use `find.byValueKey`, `find.byType`, `find.byText` to locate widgets.
    - Use `driver.tap`, `driver.enterText`, `driver.scroll` to interact with the app.

## 5. Running the Tests

The tests will be executed using the following command:
`flutter drive --target=test_driver/app.dart`

## 6. Deployment Considerations

If a test scenario requires interaction with the backend that involves a deployment, a 3-minute delay will be added to the script to allow the server to restart and be ready.
