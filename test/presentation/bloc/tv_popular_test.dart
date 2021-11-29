import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/presentation/bloc/tv_popular/tv_popular_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';
void main() {
  late MockGetPopularTv mockGetPopularTvs;
  late TvPopularBloc tvPopularBloc;

  setUp(() {
    mockGetPopularTvs = MockGetPopularTv();
    tvPopularBloc = TvPopularBloc(mockGetPopularTvs);
  });

  test("initial state should be empty", () {
    expect(tvPopularBloc.state, TvPopularEmpty());
  });

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
  final tTvList = <Tv>[tTv];

  blocTest<TvPopularBloc, TvPopularState>(
    'Should emit [Loading, Loaded] when data is gotten successfully',
    build: () {
      when(mockGetPopularTvs.execute())
          .thenAnswer((_) async => Right(tTvList));
      return tvPopularBloc;
    },
    act: (bloc) => bloc.add(TvPopularGetEvent()),
    expect: () => [TvPopularLoading(), TvPopularLoaded(tTvList)],
    verify: (bloc) {
      verify(mockGetPopularTvs.execute());
    },
  );

  blocTest<TvPopularBloc, TvPopularState>(
    'Should emit [Loading, Error] when get popular is unsuccessful',
    build: () {
      when(mockGetPopularTvs.execute())
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return tvPopularBloc;
    },
    act: (bloc) => bloc.add(TvPopularGetEvent()),
    expect: () => [
      TvPopularLoading(),
      const TvPopularError('Server Failure')
    ],
    verify: (bloc) {
      verify(mockGetPopularTvs.execute());
    },
  );
}
