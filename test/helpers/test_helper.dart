import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/data/datasources/db/database_helper.dart';
import 'package:ditonton/data/datasources/film_local_data_source.dart';
import 'package:ditonton/data/datasources/film_remote_data_source.dart';
import 'package:ditonton/domain/repositories/movie_repository.dart';
import 'package:ditonton/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton/domain/usecases/get_now_playing_tv.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:ditonton/domain/usecases/get_popular_tv.dart';
import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv.dart';
import 'package:ditonton/domain/usecases/get_tv_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_episode.dart';
import 'package:ditonton/domain/usecases/get_tv_recommendation.dart';
import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:ditonton/domain/usecases/search_movies.dart';
import 'package:ditonton/domain/usecases/search_tv.dart';
import 'package:ditonton/presentation/bloc/film_watchlist/film_watchlist_bloc.dart';
import 'package:ditonton/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/movie_now_playing/movie_now_playing_bloc.dart';
import 'package:ditonton/presentation/bloc/movie_popular/movie_popular_bloc.dart';
import 'package:ditonton/presentation/bloc/movie_recommendation/movie_recommendation_bloc.dart';
import 'package:ditonton/presentation/bloc/movie_top_rated/movie_top_rated_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_detail/tv_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_episode/tv_episode_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_now_playing/tv_now_playing_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_popular/tv_popular_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_recommendation/tv_recommendation_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_top_rated/tv_top_rated_bloc.dart';
import 'package:ditonton/presentation/provider/movie_detail_notifier.dart';
import 'package:ditonton/presentation/provider/popular_movies_notifier.dart';
import 'package:ditonton/presentation/provider/popular_tv_notifier.dart';
import 'package:ditonton/presentation/provider/top_rated_movies_notifier.dart';
import 'package:ditonton/presentation/provider/top_rated_tv_notifier.dart';
import 'package:ditonton/presentation/provider/tv_detail_notifier.dart';
import 'package:ditonton/presentation/provider/watchlist_movie_notifier.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:mockito/annotations.dart';
import 'package:mocktail/mocktail.dart' as tail;

class MockFilmWatchlistBloc
    extends MockBloc<FilmWatchlistEvent, FilmWatchlistState>
    implements FilmWatchlistBloc {}

class FilmWatchlistEventFake extends tail.Fake implements FilmWatchlistEvent {}

class FilmWatchlistStateFake extends tail.Fake implements FilmWatchlistState {}

class MockMovieRecommendationBloc
    extends MockBloc<MovieRecommendationEvent, MovieRecommendationState>
    implements MovieRecommendationBloc {}

class MovieRecommendationEventFake extends tail.Fake
    implements MovieRecommendationEvent {}

class MovieRecommendationStateFake extends tail.Fake
    implements MovieRecommendationState {}

class MockMovieDetailBloc extends MockBloc<MovieDetailEvent, MovieDetailState>
    implements MovieDetailBloc {}

class MovieDetailEventFake extends tail.Fake implements MovieDetailEvent {}

class MovieDetailStateFake extends tail.Fake implements MovieDetailState {}

class MockTvRecommendationBloc
    extends MockBloc<TvRecommendationEvent, TvRecommendationState>
    implements TvRecommendationBloc {}

class TvRecommendationEventFake extends tail.Fake
    implements TvRecommendationEvent {}

class TvRecommendationStateFake extends tail.Fake
    implements TvRecommendationState {}

class MockTvDetailBloc extends MockBloc<TvDetailEvent, TvDetailState>
    implements TvDetailBloc {}

class TvDetailEventFake extends tail.Fake implements TvDetailEvent {}

class TvDetailStateFake extends tail.Fake implements TvDetailState {}

class MockTvEpisodeBloc extends MockBloc<TvEpisodeEvent, TvEpisodeState>
    implements TvEpisodeBloc {}

class TvEpisodeEventFake extends tail.Fake implements TvEpisodeEvent {}

class TvEpisodeStateFake extends tail.Fake implements TvEpisodeState {}

class MockMoviePopularBloc
    extends MockBloc<MoviePopularEvent, MoviePopularState>
    implements MoviePopularBloc {}

class MoviePopularEventFake extends tail.Fake implements MoviePopularEvent {}

class MoviePopularStateFake extends tail.Fake implements MoviePopularState {}

class MockTvPopularBloc extends MockBloc<TvPopularEvent, TvPopularState>
    implements TvPopularBloc {}

class TvPopularEventFake extends tail.Fake implements TvPopularEvent {}

class TvPopularStateFake extends tail.Fake implements TvPopularState {}

class MockMovieTopRatedBloc
    extends MockBloc<MovieTopRatedEvent, MovieTopRatedState>
    implements MovieTopRatedBloc {}

class MovieTopRatedEventFake extends tail.Fake implements MovieTopRatedEvent {}

class MovieTopRatedStateFake extends tail.Fake implements MovieTopRatedState {}

class MockTvTopRatedBloc extends MockBloc<TvTopRatedEvent, TvTopRatedState>
    implements TvTopRatedBloc {}

class TvTopRatedEventFake extends tail.Fake implements TvTopRatedEvent {}

class TvTopRatedStateFake extends tail.Fake implements TvTopRatedState {}

class MockMovieNowPlayingBloc
    extends MockBloc<MovieNowPlayingEvent, MovieNowPlayingState>
    implements MovieNowPlayingBloc {}

class MovieNowPlayingEventFake extends tail.Fake
    implements MovieNowPlayingEvent {}

class MovieNowPlayingStateFake extends tail.Fake
    implements MovieNowPlayingState {}

class MockTvNowPlayingBloc
    extends MockBloc<TvNowPlayingEvent, TvNowPlayingState>
    implements TvNowPlayingBloc {}

class TvNowPlayingEventFake extends tail.Fake implements TvNowPlayingEvent {}

class TvNowPlayingStateFake extends tail.Fake implements TvNowPlayingState {}

@GenerateMocks([
  MovieRepository,
  FilmRemoteDataSource,
  MovieLocalDataSource,
  DatabaseHelper,
  GetMovieDetail,
  GetMovieRecommendations,
  GetWatchListStatus,
  SaveWatchlist,
  RemoveWatchlist,
  GetNowPlayingMovies,
  GetPopularMovies,
  GetTopRatedMovies,
  SearchMovies,
  GetPopularTv,
  GetTopRatedTv,
  GetTvEpisode,
  GetTvDetail,
  GetTvRecommendation,
  GetNowPlayingTv,
  SearchTv,
  GetWatchlistMovies,
  MovieDetailNotifier,
  TvDetailNotifier,
  PopularMoviesNotifier,
  PopularTvsNotifier,
  TopRatedMoviesNotifier,
  TopRatedTvsNotifier,
  WatchlistMovieNotifier,
], customMocks: [
  MockSpec<http.Client>(as: #MockHttpClient),
  MockSpec<IOClient>(as: #MockIOClient),
])
Future<void> main() async {}
