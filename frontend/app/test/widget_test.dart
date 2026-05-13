import 'package:flutter_test/flutter_test.dart';
import 'package:app/main.dart';

void main() {
  testWidgets('App loads successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const ResearchAIApp());

    expect(find.text('Research AI Assistant'), findsOneWidget);
  });
}
