import 'package:ditonton/data/models/episode_response.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/presentation/bloc/film_watchlist/film_watchlist_bloc.dart';
import 'package:ditonton/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/movie_recommendation/movie_recommendation_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_detail/tv_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_episode/tv_episode_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_recommendation/tv_recommendation_bloc.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart' as tail;
import 'package:provider/provider.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.dart';

void main() {
  late MockFilmWatchlistBloc mockFilmWatchlistBloc;
  late MockMovieDetailBloc mockMovieDetailBloc;
  late MockMovieRecommendationBloc mockMovieRecommendationBloc;
  late MockTvDetailBloc mockTvDetailBloc;
  late MockTvRecommendationBloc mockTvRecommendationBloc;
  late MockTvEpisodeBloc mockTvEpisodeBloc;

  setUp(() {
    mockFilmWatchlistBloc = MockFilmWatchlistBloc();
    mockMovieDetailBloc = MockMovieDetailBloc();
    mockMovieRecommendationBloc = MockMovieRecommendationBloc();
    mockTvDetailBloc = MockTvDetailBloc();
    mockTvRecommendationBloc = MockTvRecommendationBloc();
    mockTvEpisodeBloc = MockTvEpisodeBloc();
  });

  group("BLOC", () {
    Widget _makeTestableWidget(Widget body) {
      return MultiProvider(
        providers: [
          BlocProvider<FilmWatchlistBloc>(
            create: (_) => mockFilmWatchlistBloc,
          ),
          BlocProvider<MovieDetailBloc>(
            create: (_) => mockMovieDetailBloc,
          ),
          BlocProvider<MovieRecommendationBloc>(
            create: (_) => mockMovieRecommendationBloc,
          ),
          BlocProvider<TvDetailBloc>(
            create: (_) => mockTvDetailBloc,
          ),
          BlocProvider<TvRecommendationBloc>(
            create: (_) => mockTvRecommendationBloc,
          ),
          BlocProvider<TvEpisodeBloc>(
            create: (_) => mockTvEpisodeBloc,
          ),
        ],
        child: MaterialApp(
          home: body,
        ),
      );
    }

    setUp(() {
      tail.registerFallbackValue(FilmWatchlistStateFake());
      tail.registerFallbackValue(FilmWatchlistEventFake());
      tail.registerFallbackValue(MovieDetailStateFake());
      tail.registerFallbackValue(MovieDetailEventFake());
      tail.registerFallbackValue(MovieRecommendationStateFake());
      tail.registerFallbackValue(MovieRecommendationEventFake());
      tail.registerFallbackValue(TvDetailStateFake());
      tail.registerFallbackValue(TvDetailEventFake());
      tail.registerFallbackValue(TvRecommendationStateFake());
      tail.registerFallbackValue(TvRecommendationEventFake());
      tail.registerFallbackValue(TvEpisodeStateFake());
      tail.registerFallbackValue(TvEpisodeEventFake());
    });
    group("MOVIES", () {
      testWidgets(
          'Watchlist button should display add icon when movie not added to watchlist',
          (WidgetTester tester) async {
        tail
            .when(() => mockMovieDetailBloc.state)
            .thenReturn(const MovieDetailLoaded(testMovieDetail));
        tail
            .when(() => mockMovieRecommendationBloc.state)
            .thenReturn(const MovieRecommendationLoaded(<Movie>[]));
        tail
            .when(() => mockFilmWatchlistBloc.state)
            .thenReturn(const FilmWatchlistStatusLoaded(false));

        final watchlistButtonIcon = find.byIcon(Icons.add);

        await tester.pumpWidget(_makeTestableWidget(
            FilmDetailPage(args: FilmDetailArgs(id: 1, isMovie: true))));

        expect(watchlistButtonIcon, findsOneWidget);
      });

      testWidgets(
          'Watchlist button should dispay check icon when movie is added to wathclist',
          (WidgetTester tester) async {
        tail
            .when(() => mockMovieDetailBloc.state)
            .thenReturn(const MovieDetailLoaded(testMovieDetail));
        tail
            .when(() => mockMovieRecommendationBloc.state)
            .thenReturn(const MovieRecommendationLoaded(<Movie>[]));
        tail
            .when(() => mockFilmWatchlistBloc.state)
            .thenReturn(const FilmWatchlistStatusLoaded(true));

        final watchlistButtonIcon = find.byIcon(Icons.check);

        await tester.pumpWidget(_makeTestableWidget(
            FilmDetailPage(args: FilmDetailArgs(id: 1, isMovie: true))));

        expect(watchlistButtonIcon, findsOneWidget);
      });
    });

    group("TV SERIES", () {
      testWidgets(
          'Watchlist button should display add icon when tv not added to watchlist',
          (WidgetTester tester) async {
        tail
            .when(() => mockTvDetailBloc.state)
            .thenReturn(TvDetailLoaded(testTvDetail));
        tail
            .when(() => mockTvRecommendationBloc.state)
            .thenReturn(const TvRecommendationLoaded(<Tv>[]));
        tail
            .when(() => mockTvEpisodeBloc.state)
            .thenReturn(const TvEpisodeLoaded(<Episode>[]));
        tail
            .when(() => mockFilmWatchlistBloc.state)
            .thenReturn(const FilmWatchlistStatusLoaded(false));

        final watchlistButtonIcon = find.byIcon(Icons.add);

        await tester.pumpWidget(_makeTestableWidget(
            FilmDetailPage(args: FilmDetailArgs(id: 1, isMovie: false))));

        expect(watchlistButtonIcon, findsOneWidget);
      });

      testWidgets(
          'Watchlist button should dispay check icon when tv is added to wathclist',
          (WidgetTester tester) async {
        tail
            .when(() => mockTvDetailBloc.state)
            .thenReturn(TvDetailLoaded(testTvDetail));
        tail
            .when(() => mockTvRecommendationBloc.state)
            .thenReturn(const TvRecommendationLoaded(<Tv>[]));
        tail
            .when(() => mockTvEpisodeBloc.state)
            .thenReturn(const TvEpisodeLoaded(<Episode>[]));
        tail
            .when(() => mockFilmWatchlistBloc.state)
            .thenReturn(const FilmWatchlistStatusLoaded(true));

        final watchlistButtonIcon = find.byIcon(Icons.check);

        await tester.pumpWidget(_makeTestableWidget(
            FilmDetailPage(args: FilmDetailArgs(id: 1, isMovie: false))));

        expect(watchlistButtonIcon, findsOneWidget);
      });
    });
  });
}
