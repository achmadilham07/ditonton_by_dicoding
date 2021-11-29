import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/presentation/bloc/tv_now_playing/tv_now_playing_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockGetNowPlayingTv mockGetNowPlayingTvs;
  late TvNowPlayingBloc tvNowPlayingBloc;

  setUp(() {
    mockGetNowPlayingTvs = MockGetNowPlayingTv();
    tvNowPlayingBloc = TvNowPlayingBloc(mockGetNowPlayingTvs);
  });

  test("initial state should be empty", () {
    expect(tvNowPlayingBloc.state, TvNowPlayingEmpty());
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

  blocTest<TvNowPlayingBloc, TvNowPlayingState>(
    'Should emit [Loading, Loaded] when data is gotten successfully',
    build: () {
      when(mockGetNowPlayingTvs.execute())
          .thenAnswer((_) async => Right(tTvList));
      return tvNowPlayingBloc;
    },
    act: (bloc) => bloc.add(TvNowPlayingGetEvent()),
    expect: () => [TvNowPlayingLoading(), TvNowPlayingLoaded(tTvList)],
    verify: (bloc) {
      verify(mockGetNowPlayingTvs.execute());
    },
  );

  blocTest<TvNowPlayingBloc, TvNowPlayingState>(
    'Should emit [Loading, Error] when get now playing is unsuccessful',
    build: () {
      when(mockGetNowPlayingTvs.execute())
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return tvNowPlayingBloc;
    },
    act: (bloc) => bloc.add(TvNowPlayingGetEvent()),
    expect: () =>
        [TvNowPlayingLoading(), const TvNowPlayingError('Server Failure')],
    verify: (bloc) {
      verify(mockGetNowPlayingTvs.execute());
    },
  );
}
