import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget _makeTestableWidget(Widget body) {
    return MaterialApp(
      home: body,
    );
  }

  testWidgets('Image and Text should display', (WidgetTester tester) async {
    final image = find.byType(Image);
    final text = find.byType(Text);

    await tester.pumpWidget(_makeTestableWidget(const AboutPage()));

    expect(image, findsOneWidget);
    expect(text, findsOneWidget);
  });
}
