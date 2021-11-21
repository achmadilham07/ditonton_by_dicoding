import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:ditonton/domain/repositories/movie_repository.dart';

class SaveWatchlist {
  final MovieRepository repository;

  SaveWatchlist(this.repository);

  Future<Either<Failure, String>> executeMovie(MovieDetail tv) {
    return repository.saveMovieWatchlist(tv);
  }

  Future<Either<Failure, String>> executeTv(TvDetail tv) {
    return repository.saveTvWatchlist(tv);
  }
}
