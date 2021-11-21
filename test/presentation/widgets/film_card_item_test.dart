import 'package:ditonton/presentation/widgets/film_card_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget _makeTestableWidget(Widget body) {
    return MaterialApp(
      home: Scaffold(
        body: body,
      ),
    );
  }

  const filmCard = FilmCard(
    id: 2,
    posterPath: "/rweIrveL43TaxUN0akQEaAXL6x0.jpg",
    title: "Spider-Man",
    overview:
        'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
    isMovie: false,
  );

  testWidgets('FilmCard item should exist all', (WidgetTester tester) async {
    final txtTitle = find.text("Spider-Man");
    final txtOverview = find.text(
        'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.');
    final image = find.byType(Image);

    await tester.pumpWidget(_makeTestableWidget(filmCard));
    await tester.pump();

    expect(txtTitle, findsOneWidget);
    expect(txtOverview, findsOneWidget);
    expect(image, findsOneWidget);
  });
}
