import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group("Tetsing Driver app", () {
    final button = find.text("Log In");
    final logInPage = find.text("Log In");

    FlutterDriver driver;
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() {
      if (driver != null) {
        driver.close();
      }
    });

    test("description", () async {
      Future.delayed(Duration(seconds: 5));
      await driver.waitFor(button);
      await driver.tap(button);
      await driver.waitFor(logInPage);
      await driver.tap(button);
      assert(logInPage != null);
      Future.delayed(Duration(seconds: 5));
    });
  });
}
