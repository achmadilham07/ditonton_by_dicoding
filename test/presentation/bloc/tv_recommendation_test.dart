import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/presentation/bloc/tv_recommendation/tv_recommendation_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';
void main() {
  late MockGetTvRecommendation mockGetTvRecommendation;
  late TvRecommendationBloc tvRecommendationBloc;

  setUp(() {
    mockGetTvRecommendation = MockGetTvRecommendation();
    tvRecommendationBloc = TvRecommendationBloc(
      getTvRecommendations: mockGetTvRecommendation,
    );
  });

  test("initial state should be empty", () {
    expect(tvRecommendationBloc.state, TvRecommendationEmpty());
  });

  const tTvId = 1;
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

  blocTest<TvRecommendationBloc, TvRecommendationState>(
    'Should emit [Loading, Loaded] when data is gotten successfully',
    build: () {
      when(mockGetTvRecommendation.execute(tTvId))
          .thenAnswer((_) async => Right(tTvList));
      return tvRecommendationBloc;
    },
    act: (bloc) => bloc.add(const GetTvRecommendationEvent(tTvId)),
    expect: () => [TvRecommendationLoading(), TvRecommendationLoaded(tTvList)],
    verify: (bloc) {
      verify(mockGetTvRecommendation.execute(tTvId));
    },
  );

  blocTest<TvRecommendationBloc, TvRecommendationState>(
    'Should emit [Loading, Error] when get recommendation is unsuccessful',
    build: () {
      when(mockGetTvRecommendation.execute(tTvId))
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return tvRecommendationBloc;
    },
    act: (bloc) => bloc.add(const GetTvRecommendationEvent(tTvId)),
    expect: () => [
      TvRecommendationLoading(),
      const TvRecommendationError('Server Failure')
    ],
    verify: (bloc) {
      verify(mockGetTvRecommendation.execute(tTvId));
    },
  );
}
