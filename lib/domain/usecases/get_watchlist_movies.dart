import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/watchlist.dart';
import 'package:ditonton/domain/repositories/movie_repository.dart';

class GetWatchlistMovies {
  final MovieRepository _repository;

  GetWatchlistMovies(this._repository);

  Future<Either<Failure, List<Watchlist>>> execute() {
    return _repository.getWatchlistFilms();
  }
}
