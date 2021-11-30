import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/bloc/movie_top_rated/movie_top_rated_bloc.dart';
import 'package:ditonton/presentation/pages/top_rated_movies_page.dart';
import 'package:ditonton/presentation/provider/top_rated_movies_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mocktail/mocktail.dart' as tail;
import 'package:provider/provider.dart';

import '../../helpers/test_helper.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockTopRatedMoviesNotifier mockNotifier;
  late MockMovieTopRatedBloc mockMovieTopRatedBloc;

  setUp(() {
    mockNotifier = MockTopRatedMoviesNotifier();
    mockMovieTopRatedBloc = MockMovieTopRatedBloc();
  });

  group("PROVIDER", () {
    setUp(() {
      isProvider = true;
    });

    Widget _makeTestableWidget(Widget body) {
      return ChangeNotifierProvider<TopRatedMoviesNotifier>.value(
        value: mockNotifier,
        child: MaterialApp(
          home: body,
        ),
      );
    }

    testWidgets('Page should display progress bar when loading',
        (WidgetTester tester) async {
      when(mockNotifier.state).thenReturn(RequestState.loading);

      final progressFinder = find.byType(CircularProgressIndicator);
      final centerFinder = find.byType(Center);

      await tester.pumpWidget(_makeTestableWidget(const TopRatedMoviesPage()));

      expect(centerFinder, findsOneWidget);
      expect(progressFinder, findsOneWidget);
    });

    testWidgets('Page should display when data is loaded',
        (WidgetTester tester) async {
      when(mockNotifier.state).thenReturn(RequestState.loaded);
      when(mockNotifier.movies).thenReturn(<Movie>[]);

      final listViewFinder = find.byType(ListView);

      await tester.pumpWidget(_makeTestableWidget(const TopRatedMoviesPage()));

      expect(listViewFinder, findsOneWidget);
    });

    testWidgets('Page should display text with message when Error',
        (WidgetTester tester) async {
      when(mockNotifier.state).thenReturn(RequestState.error);
      when(mockNotifier.message).thenReturn('Error message');

      final textFinder = find.byKey(const Key('error_message'));

      await tester.pumpWidget(_makeTestableWidget(const TopRatedMoviesPage()));

      expect(textFinder, findsOneWidget);
    });
  });

  group("BLOC", () {
    setUp(() {
      isProvider = false;
    });

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
