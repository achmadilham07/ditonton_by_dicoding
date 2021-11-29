import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/presentation/bloc/tv_top_rated/tv_top_rated_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockGetTopRatedTv mockGetTopRatedTvs;
  late TvTopRatedBloc tvTopRatedBloc;

  setUp(() {
    mockGetTopRatedTvs = MockGetTopRatedTv();
    tvTopRatedBloc = TvTopRatedBloc(mockGetTopRatedTvs);
  });

  test("initial state should be empty", () {
    expect(tvTopRatedBloc.state, TvTopRatedEmpty());
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

  blocTest<TvTopRatedBloc, TvTopRatedState>(
    'Should emit [Loading, Loaded] when data is gotten successfully',
    build: () {
      when(mockGetTopRatedTvs.execute())
          .thenAnswer((_) async => Right(tTvList));
      return tvTopRatedBloc;
    },
    act: (bloc) => bloc.add(TvTopRatedGetEvent()),
    expect: () => [TvTopRatedLoading(), TvTopRatedLoaded(tTvList)],
    verify: (bloc) {
      verify(mockGetTopRatedTvs.execute());
    },
  );

  blocTest<TvTopRatedBloc, TvTopRatedState>(
    'Should emit [Loading, Error] when get top rated is unsuccessful',
    build: () {
      when(mockGetTopRatedTvs.execute())
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return tvTopRatedBloc;
    },
    act: (bloc) => bloc.add(TvTopRatedGetEvent()),
    expect: () =>
        [TvTopRatedLoading(), const TvTopRatedError('Server Failure')],
    verify: (bloc) {
      verify(mockGetTopRatedTvs.execute());
    },
  );
}
