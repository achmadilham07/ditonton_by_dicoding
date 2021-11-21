import 'package:ditonton/data/models/movie_model.dart';
import 'package:ditonton/data/models/tv_model.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("MOVIES", () {
    const tMovieModel = MovieModel(
      adult: false,
      backdropPath: 'backdropPath',
      genreIds: [1, 2, 3],
      id: 1,
      originalTitle: 'originalTitle',
      overview: 'overview',
      popularity: 1,
      posterPath: 'posterPath',
      releaseDate: 'releaseDate',
      title: 'title',
      video: false,
      voteAverage: 1,
      voteCount: 1,
    );

    final tMovie = Movie(
      adult: false,
      backdropPath: 'backdropPath',
      genreIds: const [1, 2, 3],
      id: 1,
      originalTitle: 'originalTitle',
      overview: 'overview',
      popularity: 1,
      posterPath: 'posterPath',
      releaseDate: 'releaseDate',
      title: 'title',
      video: false,
      voteAverage: 1,
      voteCount: 1,
    );

    test('should be a subclass of Movie entity', () async {
      final result = tMovieModel.toEntity();
      expect(result, tMovie);
    });
  });

  group("TV SERIES", () {
    final tTvModel = TvModel(
      voteCount: 213,
      voteAverage: 7.3,
      backdropPath: 'backdropPath',
      posterPath: 'posterPath',
      popularity: 4.5,
      overview: 'overview',
      originalName: 'originalName',
      originalLanguage: 'originalLanguage',
      originCountry: const ['originCountry'],
      name: 'name',
      id: 1,
      genreIds: const [1, 2, 3],
      firstAirDate: 'firstAirDate',
    );

    final tTv = Tv(
      backdropPath: 'backdropPath',
      genreIds: const [1, 2, 3],
      id: 1,
      overview: 'overview',
      popularity: 4.5,
      posterPath: 'posterPath',
      voteAverage: 7.3,
      voteCount: 213,
      originalName: 'originalName',
      originalLanguage: 'originalLanguage',
      originCountry: const ['originCountry'],
      name: 'name',
      firstAirDate: 'firstAirDate',
    );

    test('should be a subclass of Tv entity', () async {
      final result = tTvModel.toEntity();
      expect(result, tTv);
    });
  });
}
