import 'package:ditonton/domain/repositories/movie_repository.dart';

class GetWatchListStatus {
  final MovieRepository repository;

  GetWatchListStatus(this.repository);

  Future<bool> executeMovie(int id) async {
    return repository.isAddedToMovieWatchlist(id);
  }

  Future<bool> executeTv(int id) async {
    return repository.isAddedToTvWatchlist(id);
  }
}
