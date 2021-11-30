import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/presentation/bloc/tv_episode/tv_episode_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockGetTvEpisode mockGetTvEpisode;
  late TvEpisodeBloc tvEpisodeBloc;

  setUp(() {
    mockGetTvEpisode = MockGetTvEpisode();
    tvEpisodeBloc = TvEpisodeBloc(mockGetTvEpisode);
  });

  const idTv = 1;
  const idEpisode = 1;

  test("initial state should be empty", () {
    expect(tvEpisodeBloc.state, TvEpisodeEmpty());
  });

  blocTest<TvEpisodeBloc, TvEpisodeState>(
    'Should emit [Loading, Loaded] when data is gotten successfully',
    build: () {
      when(mockGetTvEpisode.execute(idTv, idEpisode))
          .thenAnswer((_) async => Right(testTvEpisodeList));
      return tvEpisodeBloc;
    },
    act: (bloc) => bloc.add(const TvEpisodeGetEvent(idTv, idEpisode)),
    expect: () => [TvEpisodeLoading(), TvEpisodeLoaded(testTvEpisodeList)],
    verify: (bloc) {
      verify(mockGetTvEpisode.execute(idTv, idEpisode));
    },
  );

  blocTest<TvEpisodeBloc, TvEpisodeState>(
    'Should emit [Loading, Error] when get popular is unsuccessful',
    build: () {
      when(mockGetTvEpisode.execute(idTv, idEpisode))
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return tvEpisodeBloc;
    },
    act: (bloc) => bloc.add(const TvEpisodeGetEvent(idTv, idEpisode)),
    expect: () => [TvEpisodeLoading(), const TvEpisodeError('Server Failure')],
    verify: (bloc) {
      verify(mockGetTvEpisode.execute(idTv, idEpisode));
    },
  );
}
