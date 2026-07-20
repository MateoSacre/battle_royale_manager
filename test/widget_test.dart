import 'package:flutter_test/flutter_test.dart';

import 'package:battle_royale_manager/main.dart';

void main() {
  testWidgets('App builds without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('Battle Royale Manager'), findsOneWidget);
  });
}
