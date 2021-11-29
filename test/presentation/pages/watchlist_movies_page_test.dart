import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/watchlist.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/presentation/bloc/film_watchlist/film_watchlist_bloc.dart';
import 'package:ditonton/presentation/pages/watchlist_movies_page.dart';
import 'package:ditonton/presentation/provider/watchlist_movie_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:mocktail/mocktail.dart' as tail;

import '../../helpers/test_helper.dart';
import 'watchlist_movies_page_test.mocks.dart';

@GenerateMocks([WatchlistMovieNotifier])
void main() {
  late MockWatchlistMovieNotifier mockNotifier;
  late MockFilmWatchlistBloc mockFilmWatchlistBloc;

  setUp(() {
    mockNotifier = MockWatchlistMovieNotifier();
    mockFilmWatchlistBloc = MockFilmWatchlistBloc();
  });

  group("PROVIDER", () {
    setUp(() {
      isProvider = true;
    });
    Widget _makeTestableWidget(Widget body) {
      return ChangeNotifierProvider<WatchlistMovieNotifier>.value(
        value: mockNotifier,
        child: MaterialApp(
          home: body,
        ),
      );
    }

    testWidgets('Page should display center progress bar when loading',
        (WidgetTester tester) async {
      when(mockNotifier.watchlistState).thenReturn(RequestState.loading);

      final progressBarFinder = find.byType(CircularProgressIndicator);
      final centerFinder = find.byType(Center);

      await tester.pumpWidget(_makeTestableWidget(const WatchlistMoviesPage()));

      expect(centerFinder, findsOneWidget);
      expect(progressBarFinder, findsOneWidget);
    });

    testWidgets('Page should display ListView when data is loaded',
        (WidgetTester tester) async {
      when(mockNotifier.watchlistState).thenReturn(RequestState.loaded);
      when(mockNotifier.watchlistMovies).thenReturn(<Watchlist>[]);

      final listViewFinder = find.byType(ListView);

      await tester.pumpWidget(_makeTestableWidget(const WatchlistMoviesPage()));

      expect(listViewFinder, findsOneWidget);
    });

    testWidgets('Page should display text with message when Error',
        (WidgetTester tester) async {
      when(mockNotifier.watchlistState).thenReturn(RequestState.error);
      when(mockNotifier.message).thenReturn('Error message');

      final textFinder = find.byKey(const Key('error_message'));

      await tester.pumpWidget(_makeTestableWidget(const WatchlistMoviesPage()));

      expect(textFinder, findsOneWidget);
    });
  });
  group("BLOC", () {
    setUp(() {
      isProvider = false;
      tail.registerFallbackValue(FilmWatchlistStateFake());
      tail.registerFallbackValue(FilmWatchlistEventFake());
    });
    Widget _makeTestableWidget(Widget body) {
      return BlocProvider<FilmWatchlistBloc>(
        create: (_) => mockFilmWatchlistBloc,
        child: MaterialApp(
          home: body,
        ),
      );
    }

    testWidgets('Page should display center text when nothing',
        (WidgetTester tester) async {
      tail.when(() => mockFilmWatchlistBloc.state).thenReturn(FilmWatchlistEmpty());

      final textFinder = find.byKey(const Key('error_message'));

      await tester.pumpWidget(_makeTestableWidget(const WatchlistMoviesPage()));

      expect(textFinder, findsOneWidget);
    });

    testWidgets('Page should display center progress bar when loading',
        (WidgetTester tester) async {
      tail
          .when(() => mockFilmWatchlistBloc.state)
          .thenReturn(FilmWatchlistLoading());

      final progressBarFinder = find.byType(CircularProgressIndicator);
      final centerFinder = find.byType(Center);

      await tester.pumpWidget(_makeTestableWidget(const WatchlistMoviesPage()));

      expect(centerFinder, findsOneWidget);
      expect(progressBarFinder, findsOneWidget);
    });

    testWidgets('Page should display ListView when data is loaded',
        (WidgetTester tester) async {
      tail
          .when(() => mockFilmWatchlistBloc.state)
          .thenReturn(const FilmWatchlistLoaded(<Watchlist>[]));

      final listViewFinder = find.byType(ListView);

      await tester.pumpWidget(_makeTestableWidget(const WatchlistMoviesPage()));

      expect(listViewFinder, findsOneWidget);
    });

    testWidgets('Page should display text with message when Error',
        (WidgetTester tester) async {
      tail
          .when(() => mockFilmWatchlistBloc.state)
          .thenReturn(const FilmWatchlistError('Error message'));

      final textFinder = find.byKey(const Key('error_message'));

      await tester.pumpWidget(_makeTestableWidget(const WatchlistMoviesPage()));

      expect(textFinder, findsOneWidget);
    });
  });
}
