import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/presentation/bloc/tv_popular/tv_popular_bloc.dart';
import 'package:ditonton/presentation/pages/popular_tv_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart' as tail;

import '../../helpers/test_helper.dart';

void main() {
  late MockTvPopularBloc mockTvPopularBloc;

  setUp(() {
    mockTvPopularBloc = MockTvPopularBloc();
  });

  group("BLOC", () {
    setUp(() {
      tail.registerFallbackValue(TvPopularEventFake());
      tail.registerFallbackValue(TvPopularStateFake());
    });

    Widget _makeTestableWidget(Widget body) {
      return BlocProvider<TvPopularBloc>(
        create: (_) => mockTvPopularBloc,
        child: MaterialApp(
          home: body,
        ),
      );
    }

    testWidgets('Page should display center text when nothing',
        (WidgetTester tester) async {
      tail.when(() => mockTvPopularBloc.state).thenReturn(TvPopularEmpty());

      final textFinder = find.byKey(const Key('error_message'));

      await tester.pumpWidget(_makeTestableWidget(const PopularTvsPage()));

      expect(textFinder, findsOneWidget);
    });

    testWidgets('Page should display center progress bar when loading',
        (WidgetTester tester) async {
      tail.when(() => mockTvPopularBloc.state).thenReturn(TvPopularLoading());

      final progressBarFinder = find.byType(CircularProgressIndicator);
      final centerFinder = find.byType(Center);

      await tester.pumpWidget(_makeTestableWidget(const PopularTvsPage()));

      expect(centerFinder, findsOneWidget);
      expect(progressBarFinder, findsOneWidget);
    });

    testWidgets('Page should display ListView when data is loaded',
        (WidgetTester tester) async {
      tail
          .when(() => mockTvPopularBloc.state)
          .thenReturn(const TvPopularLoaded(<Tv>[]));

      final listViewFinder = find.byType(ListView);

      await tester.pumpWidget(_makeTestableWidget(const PopularTvsPage()));

      expect(listViewFinder, findsOneWidget);
    });

    testWidgets('Page should display text with message when Error',
        (WidgetTester tester) async {
      tail
          .when(() => mockTvPopularBloc.state)
          .thenReturn(const TvPopularError('Error message'));

      final textFinder = find.byKey(const Key('error_message'));

      await tester.pumpWidget(_makeTestableWidget(const PopularTvsPage()));

      expect(textFinder, findsOneWidget);
    });
  });
}
