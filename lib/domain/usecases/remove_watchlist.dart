import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:ditonton/domain/repositories/movie_repository.dart';

class RemoveWatchlist {
  final MovieRepository repository;

  RemoveWatchlist(this.repository);

  Future<Either<Failure, String>> executeMovie(MovieDetail film) {
    return repository.removeMovieWatchlist(film);
  }

  Future<Either<Failure, String>> executeTv(TvDetail film) {
    return repository.removeTvWatchlist(film);
  }
}
