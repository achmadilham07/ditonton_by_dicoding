import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/bloc/movie_popular/movie_popular_bloc.dart';
import 'package:ditonton/presentation/pages/popular_movies_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart' as tail;

import '../../helpers/test_helper.dart';

void main() {
  late MockMoviePopularBloc mockMoviePopularBloc;

  setUp(() {
    mockMoviePopularBloc = MockMoviePopularBloc();
  });

  group("BLOC", () {
    setUp(() {
      tail.registerFallbackValue(MoviePopularStateFake());
      tail.registerFallbackValue(MoviePopularEventFake());
    });

    Widget _makeTestableWidget(Widget body) {
      return BlocProvider<MoviePopularBloc>(
        create: (_) => mockMoviePopularBloc,
        child: MaterialApp(
          home: body,
        ),
      );
    }

    testWidgets('Page should display center text when nothing',
        (WidgetTester tester) async {
      tail
          .when(() => mockMoviePopularBloc.state)
          .thenReturn(MoviePopularEmpty());

      final textFinder = find.byKey(const Key('error_message'));

      await tester.pumpWidget(_makeTestableWidget(const PopularMoviesPage()));

      expect(textFinder, findsOneWidget);
    });

    testWidgets('Page should display center progress bar when loading',
        (WidgetTester tester) async {
      tail
          .when(() => mockMoviePopularBloc.state)
          .thenReturn(MoviePopularLoading());

      final progressBarFinder = find.byType(CircularProgressIndicator);
      final centerFinder = find.byType(Center);

      await tester.pumpWidget(_makeTestableWidget(const PopularMoviesPage()));

      expect(centerFinder, findsOneWidget);
      expect(progressBarFinder, findsOneWidget);
    });

    testWidgets('Page should display ListView when data is loaded',
        (WidgetTester tester) async {
      tail
          .when(() => mockMoviePopularBloc.state)
          .thenReturn(const MoviePopularLoaded(<Movie>[]));

      final listViewFinder = find.byType(ListView);

      await tester.pumpWidget(_makeTestableWidget(const PopularMoviesPage()));

      expect(listViewFinder, findsOneWidget);
    });

    testWidgets('Page should display text with message when Error',
        (WidgetTester tester) async {
      tail
          .when(() => mockMoviePopularBloc.state)
          .thenReturn(const MoviePopularError('Error message'));

      final textFinder = find.byKey(const Key('error_message'));

      await tester.pumpWidget(_makeTestableWidget(const PopularMoviesPage()));

      expect(textFinder, findsOneWidget);
    });
  });
}
