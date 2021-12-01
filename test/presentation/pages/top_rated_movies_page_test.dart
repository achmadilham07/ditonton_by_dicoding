import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/bloc/movie_top_rated/movie_top_rated_bloc.dart';
import 'package:ditonton/presentation/pages/top_rated_movies_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart' as tail;

import '../../helpers/test_helper.dart';

void main() {
  late MockMovieTopRatedBloc mockMovieTopRatedBloc;

  setUp(() {
    mockMovieTopRatedBloc = MockMovieTopRatedBloc();
  });

  group("BLOC", () {
    Widget _makeTestableWidget(Widget body) {
      return BlocProvider<MovieTopRatedBloc>(
        create: (_) => mockMovieTopRatedBloc,
        child: MaterialApp(
          home: body,
        ),
      );
    }

    testWidgets('Page should display center text when nothing',
        (WidgetTester tester) async {
      tail
          .when(() => mockMovieTopRatedBloc.state)
          .thenReturn(MovieTopRatedEmpty());

      final textFinder = find.byKey(const Key('error_message'));

      await tester.pumpWidget(_makeTestableWidget(const TopRatedMoviesPage()));

      expect(textFinder, findsOneWidget);
    });

    testWidgets('Page should display progress bar when loading',
        (WidgetTester tester) async {
      tail
          .when(() => mockMovieTopRatedBloc.state)
          .thenReturn(MovieTopRatedLoading());

      final progressFinder = find.byType(CircularProgressIndicator);
      final centerFinder = find.byType(Center);

      await tester.pumpWidget(_makeTestableWidget(const TopRatedMoviesPage()));

      expect(centerFinder, findsOneWidget);
      expect(progressFinder, findsOneWidget);
    });

    testWidgets('Page should display when data is loaded',
        (WidgetTester tester) async {
      tail
          .when(() => mockMovieTopRatedBloc.state)
          .thenReturn(const MovieTopRatedLoaded(<Movie>[]));

      final listViewFinder = find.byType(ListView);

      await tester.pumpWidget(_makeTestableWidget(const TopRatedMoviesPage()));

      expect(listViewFinder, findsOneWidget);
    });

    testWidgets('Page should display text with message when Error',
        (WidgetTester tester) async {
      tail
          .when(() => mockMovieTopRatedBloc.state)
          .thenReturn(const MovieTopRatedError('Error message'));

      final textFinder = find.byKey(const Key('error_message'));

      await tester.pumpWidget(_makeTestableWidget(const TopRatedMoviesPage()));

      expect(textFinder, findsOneWidget);
    });
  });
}
