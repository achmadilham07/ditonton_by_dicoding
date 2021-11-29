import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/presentation/bloc/tv_detail/tv_detail_bloc.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';
void main() {
  late MockGetTvDetail mockGetTvDetail;
  late TvDetailBloc tvDetailBloc;

  setUp(() {
    mockGetTvDetail = MockGetTvDetail();
    tvDetailBloc = TvDetailBloc(getTvDetail: mockGetTvDetail);
  });

  test("initial state should be empty", () {
    expect(tvDetailBloc.state, TvDetailEmpty());
  });

  const tTvId = 1;

  blocTest<TvDetailBloc, TvDetailState>(
    'Should emit [Loading, Loaded] when data is gotten successfully',
    build: () {
      when(mockGetTvDetail.execute(tTvId))
          .thenAnswer((_) async => Right(testTvDetail));
      return tvDetailBloc;
    },
    act: (bloc) => bloc.add(const GetTvDetailEvent(tTvId)),
    expect: () =>
        [TvDetailLoading(), TvDetailLoaded(testTvDetail)],
    verify: (bloc) {
      verify(mockGetTvDetail.execute(tTvId));
    },
  );

  blocTest<TvDetailBloc, TvDetailState>(
    'Should emit [Loading, Error] when get detail is unsuccessful',
    build: () {
      when(mockGetTvDetail.execute(tTvId))
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return tvDetailBloc;
    },
    act: (bloc) => bloc.add(const GetTvDetailEvent(tTvId)),
    expect: () =>
        [TvDetailLoading(), const TvDetailError('Server Failure')],
    verify: (bloc) {
      verify(mockGetTvDetail.execute(tTvId));
    },
  );
}
