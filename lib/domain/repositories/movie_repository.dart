import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/data/models/episode_response.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:ditonton/domain/entities/watchlist.dart';

abstract class MovieRepository {
  ///
  /// REMOTE
  ///

  /// Movie
  Future<Either<Failure, List<Movie>>> getNowPlayingMovies();

  Future<Either<Failure, List<Movie>>> getPopularMovies();

  Future<Either<Failure, List<Movie>>> getTopRatedMovies();

  Future<Either<Failure, MovieDetail>> getMovieDetail(int id);

  Future<Either<Failure, List<Movie>>> getMovieRecommendations(int id);

  Future<Either<Failure, List<Movie>>> searchMovies(String query);

  /// Tv
  Future<Either<Failure, List<Tv>>> getNowPlayingTv();

  Future<Either<Failure, List<Tv>>> getPopularTv();

  Future<Either<Failure, List<Tv>>> getTopRatedTv();

  Future<Either<Failure, TvDetail>> getTvDetail(int id);

  Future<Either<Failure, List<Episode>>> getTvEpisode(int idTv, int idEpisode);

  Future<Either<Failure, List<Tv>>> getTvRecommendations(int id);

  Future<Either<Failure, List<Tv>>> searchTv(String query);

  ///
  /// LOCAL
  ///

  Future<Either<Failure, List<Watchlist>>> getWatchlistFilms();

  /// Movie
  Future<bool> isAddedToMovieWatchlist(int id);

  Future<Either<Failure, String>> saveMovieWatchlist(MovieDetail movie);

  Future<Either<Failure, String>> removeMovieWatchlist(MovieDetail movie);

  /// Tv
  Future<bool> isAddedToTvWatchlist(int id);

  Future<Either<Failure, String>> saveTvWatchlist(TvDetail movie);

  Future<Either<Failure, String>> removeTvWatchlist(TvDetail movie);
}
