// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:SHM_app/main.dart';
import 'package:SHM_app/utils/constants.dart';

void main() {
  testWidgets('App launches and shows splash screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const SahmApp());
    await tester.pump();

    expect(find.text(AppConstants.appName), findsOneWidget);
  });
}
