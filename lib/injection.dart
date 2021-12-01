import 'package:ditonton/data/datasources/db/database_helper.dart';
import 'package:ditonton/data/datasources/film_local_data_source.dart';
import 'package:ditonton/data/datasources/film_remote_data_source.dart';
import 'package:ditonton/data/datasources/ssl/ssl_pinning.dart';
import 'package:ditonton/data/repositories/movie_repository_impl.dart';
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
import 'package:ditonton/presentation/bloc/movie_search/movie_search_bloc.dart';
import 'package:ditonton/presentation/bloc/movie_top_rated/movie_top_rated_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_detail/tv_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_episode/tv_episode_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_now_playing/tv_now_playing_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_popular/tv_popular_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_recommendation/tv_recommendation_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_search/tv_search_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_top_rated/tv_top_rated_bloc.dart';
import 'package:ditonton/presentation/provider/movie_detail_notifier.dart';
import 'package:ditonton/presentation/provider/movie_list_notifier.dart';
import 'package:ditonton/presentation/provider/movie_search_notifier.dart';
import 'package:ditonton/presentation/provider/popular_movies_notifier.dart';
import 'package:ditonton/presentation/provider/popular_tv_notifier.dart';
import 'package:ditonton/presentation/provider/top_rated_movies_notifier.dart';
import 'package:ditonton/presentation/provider/top_rated_tv_notifier.dart';
import 'package:ditonton/presentation/provider/tv_detail_notifier.dart';
import 'package:ditonton/presentation/provider/tv_list_notifier.dart';
import 'package:ditonton/presentation/provider/tv_search_notifier.dart';
import 'package:ditonton/presentation/provider/watchlist_movie_notifier.dart';
import 'package:get_it/get_it.dart';
import 'package:http/io_client.dart';

final locator = GetIt.instance;

Future init() async {
  IOClient ioClient = await SSLPinning.ioClient;

  /// provider
  locator.registerFactory(
    () => MovieListNotifier(
      getNowPlayingMovies: locator(),
      getPopularMovies: locator(),
      getTopRatedMovies: locator(),
    ),
  );
  locator.registerFactory(
    () => MovieDetailNotifier(
      getMovieDetail: locator(),
      getMovieRecommendations: locator(),
      getWatchListStatus: locator(),
      saveWatchlist: locator(),
      removeWatchlist: locator(),
    ),
  );
  locator.registerFactory(
    () => MovieSearchNotifier(
      searchMovies: locator(),
    ),
  );
  locator.registerFactory(
    () => PopularMoviesNotifier(
      locator(),
    ),
  );
  locator.registerFactory(
    () => TopRatedMoviesNotifier(
      getTopRatedMovies: locator(),
    ),
  );
  locator.registerFactory(
    () => WatchlistMovieNotifier(
      getWatchlistMovies: locator(),
    ),
  );

  locator.registerFactory(
    () => TvListNotifier(
      getNowPlayingTvs: locator(),
      getPopularTvs: locator(),
      getTopRatedTvs: locator(),
    ),
  );
  locator.registerFactory(
    () => TvDetailNotifier(
      getTvEpisode: locator(),
      getTvDetail: locator(),
      getTvRecommendations: locator(),
      getWatchListStatus: locator(),
      saveWatchlist: locator(),
      removeWatchlist: locator(),
    ),
  );
  locator.registerFactory(
    () => TvSearchNotifier(
      searchTvs: locator(),
    ),
  );
  locator.registerFactory(
    () => PopularTvsNotifier(
      locator(),
    ),
  );
  locator.registerFactory(
    () => TopRatedTvsNotifier(
      getTopRatedTvs: locator(),
    ),
  );

  /// Bloc
  locator.registerFactory(() => FilmWatchlistBloc(
        getFilmWatchlists: locator(),
        getWatchListStatus: locator(),
        saveWatchlist: locator(),
        removeWatchlist: locator(),
      ));
  locator.registerFactory(() => MovieDetailBloc(
        getMovieDetail: locator(),
      ));
  locator.registerFactory(
    () => MoviePopularBloc(locator()),
  );
  locator.registerFactory(() => MovieRecommendationBloc(
        getMovieRecommendations: locator(),
      ));
  locator.registerFactory(() => MovieSearchBloc(
        searchMovies: locator(),
      ));
  locator.registerFactory(
    () => MovieTopRatedBloc(locator()),
  );
  locator.registerFactory(() => TvDetailBloc(
        getTvDetail: locator(),
      ));
  locator.registerFactory(
    () => TvPopularBloc(locator()),
  );
  locator.registerFactory(() => TvRecommendationBloc(
        getTvRecommendations: locator(),
      ));
  locator.registerFactory(() => TvSearchBloc(
        searchTvs: locator(),
      ));
  locator.registerFactory(
    () => TvTopRatedBloc(locator()),
  );
  locator.registerFactory(
    () => TvNowPlayingBloc(locator()),
  );
  locator.registerFactory(
    () => MovieNowPlayingBloc(locator()),
  );
  locator.registerFactory(
    () => TvEpisodeBloc(locator()),
  );

  /// use case
  locator.registerLazySingleton(() => GetNowPlayingMovies(locator()));
  locator.registerLazySingleton(() => GetPopularMovies(locator()));
  locator.registerLazySingleton(() => GetTopRatedMovies(locator()));
  locator.registerLazySingleton(() => GetMovieDetail(locator()));
  locator.registerLazySingleton(() => GetMovieRecommendations(locator()));
  locator.registerLazySingleton(() => SearchMovies(locator()));

  locator.registerLazySingleton(() => GetTvEpisode(locator()));
  locator.registerLazySingleton(() => GetNowPlayingTv(locator()));
  locator.registerLazySingleton(() => GetPopularTv(locator()));
  locator.registerLazySingleton(() => GetTopRatedTv(locator()));
  locator.registerLazySingleton(() => GetTvDetail(locator()));
  locator.registerLazySingleton(() => GetTvRecommendation(locator()));
  locator.registerLazySingleton(() => SearchTv(locator()));

  locator.registerLazySingleton(() => GetWatchListStatus(locator()));
  locator.registerLazySingleton(() => SaveWatchlist(locator()));
  locator.registerLazySingleton(() => RemoveWatchlist(locator()));
  locator.registerLazySingleton(() => GetWatchlistMovies(locator()));

  /// repository
  locator.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );

  /// data sources
  locator.registerLazySingleton<FilmRemoteDataSource>(
      () => FilmRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<MovieLocalDataSource>(
      () => MovieLocalDataSourceImpl(databaseHelper: locator()));

  /// helper
  locator.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());

  /// external
  locator.registerLazySingleton<IOClient>(() => ioClient);
}
