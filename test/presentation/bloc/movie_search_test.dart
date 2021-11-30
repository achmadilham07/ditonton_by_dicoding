import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/bloc/movie_search/movie_search_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockSearchMovies mockSearchMovies;
  late MovieSearchBloc movieSearchBloc;

  setUp(() {
    mockSearchMovies = MockSearchMovies();
    movieSearchBloc = MovieSearchBloc(
      searchMovies: mockSearchMovies,
    );
  });

  test("initial state should be empty", () {
    expect(movieSearchBloc.state, MovieSearchEmpty());
  });

  const query = "overview";
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
  final tMovieList = <Movie>[tMovie];

  blocTest<MovieSearchBloc, MovieSearchState>(
    'Should emit [Loading, Loaded] when data is gotten successfully',
    build: () {
      when(mockSearchMovies.execute(query))
          .thenAnswer((_) async => Right(tMovieList));
      return movieSearchBloc;
    },
    act: (bloc) => bloc.add(const MovieSearchQueryEvent(query)),
    expect: () => [MovieSearchLoading(), MovieSearchLoaded(tMovieList)],
    verify: (bloc) {
      verify(mockSearchMovies.execute(query));
    },
  );

  blocTest<MovieSearchBloc, MovieSearchState>(
    'Should emit [Loading, Error] when get search is unsuccessful',
    build: () {
      when(mockSearchMovies.execute(query))
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return movieSearchBloc;
    },
    act: (bloc) => bloc.add(const MovieSearchQueryEvent(query)),
    expect: () =>
        [MovieSearchLoading(), const MovieSearchError('Server Failure')],
    verify: (bloc) {
      verify(mockSearchMovies.execute(query));
    },
  );
}
