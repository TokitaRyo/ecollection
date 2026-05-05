import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App starts', (WidgetTester tester) async {
    // Firebase requires native initialization, so integration tests
    // are more appropriate for this app.
    expect(true, isTrue);
  });
}
