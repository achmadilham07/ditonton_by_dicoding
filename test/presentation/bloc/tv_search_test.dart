import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/presentation/bloc/tv_search/tv_search_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';
void main() {
  late MockSearchTv mockSearchTvs;
  late TvSearchBloc tvSearchBloc;

  setUp(() {
    mockSearchTvs = MockSearchTv();
    tvSearchBloc = TvSearchBloc(
      searchTvs: mockSearchTvs,
    );
  });

  test("initial state should be empty", () {
    expect(tvSearchBloc.state, TvSearchEmpty());
  });

  const query = "overview";
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

  blocTest<TvSearchBloc, TvSearchState>(
    'Should emit [Loading, Loaded] when data is gotten successfully',
    build: () {
      when(mockSearchTvs.execute(query))
          .thenAnswer((_) async => Right(tTvList));
      return tvSearchBloc;
    },
    act: (bloc) => bloc.add(const TvSearchQueryEvent(query)),
    expect: () => [TvSearchLoading(), TvSearchLoaded(tTvList)],
    verify: (bloc) {
      verify(mockSearchTvs.execute(query));
    },
  );

  blocTest<TvSearchBloc, TvSearchState>(
    'Should emit [Loading, Error] when get search is unsuccessful',
    build: () {
      when(mockSearchTvs.execute(query))
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return tvSearchBloc;
    },
    act: (bloc) => bloc.add(const TvSearchQueryEvent(query)),
    expect: () => [
      TvSearchLoading(),
      const TvSearchError('Server Failure')
    ],
    verify: (bloc) {
      verify(mockSearchTvs.execute(query));
    },
  );
}
