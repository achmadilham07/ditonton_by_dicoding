import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockGetMovieDetail mockGetMovieDetail;
  late MovieDetailBloc movieDetailBloc;

  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    movieDetailBloc = MovieDetailBloc(getMovieDetail: mockGetMovieDetail);
  });

  test("initial state should be empty", () {
    expect(movieDetailBloc.state, MovieDetailEmpty());
  });

  const tMovieId = 1;

  blocTest<MovieDetailBloc, MovieDetailState>(
    'Should emit [Loading, Loaded] when data is gotten successfully',
    build: () {
      when(mockGetMovieDetail.execute(tMovieId))
          .thenAnswer((_) async => const Right(testMovieDetail));
      return movieDetailBloc;
    },
    act: (bloc) => bloc.add(const GetMovieDetailEvent(tMovieId)),
    expect: () =>
        [MovieDetailLoading(), const MovieDetailLoaded(testMovieDetail)],
    verify: (bloc) {
      verify(mockGetMovieDetail.execute(tMovieId));
    },
  );

  blocTest<MovieDetailBloc, MovieDetailState>(
    'Should emit [Loading, Error] when get detail is unsuccessful',
    build: () {
      when(mockGetMovieDetail.execute(tMovieId))
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return movieDetailBloc;
    },
    act: (bloc) => bloc.add(const GetMovieDetailEvent(tMovieId)),
    expect: () =>
        [MovieDetailLoading(), const MovieDetailError('Server Failure')],
    verify: (bloc) {
      verify(mockGetMovieDetail.execute(tMovieId));
    },
  );
}
