import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/data/models/episode_response.dart';
import 'package:ditonton/domain/repositories/movie_repository.dart';

class GetTvEpisode {
  final MovieRepository repository;

  GetTvEpisode(this.repository);

  Future<Either<Failure, List<Episode>>> execute(int idTv, int idEpisode) {
    return repository.getTvEpisode(idTv, idEpisode);
  }
}
