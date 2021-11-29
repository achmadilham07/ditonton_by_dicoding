import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/presentation/bloc/film_watchlist/film_watchlist_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:ditonton/common/failure.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockGetWatchlistMovies mockGetWatchlistMovies;
  late MockGetWatchListStatus mockGetWatchListStatus;
  late MockSaveWatchlist mockSaveWatchlist;
  late MockRemoveWatchlist mockRemoveWatchlist;
  late FilmWatchlistBloc filmWatchlistBloc;

  setUp(() {
    mockGetWatchlistMovies = MockGetWatchlistMovies();
    mockGetWatchListStatus = MockGetWatchListStatus();
    mockSaveWatchlist = MockSaveWatchlist();
    mockRemoveWatchlist = MockRemoveWatchlist();
    filmWatchlistBloc = FilmWatchlistBloc(
      getFilmWatchlists: mockGetWatchlistMovies,
      getWatchListStatus: mockGetWatchListStatus,
      saveWatchlist: mockSaveWatchlist,
      removeWatchlist: mockRemoveWatchlist,
    );
  });

  const tFilmId = 1;

  test("initial state should be empty", () {
    expect(filmWatchlistBloc.state, FilmWatchlistEmpty());
  });

  blocTest<FilmWatchlistBloc, FilmWatchlistState>(
    'Should emit [Loading, Loaded] when data is gotten successfully',
    build: () {
      when(mockGetWatchlistMovies.execute())
          .thenAnswer((_) async => Right(testWatchlistMovieList));
      return filmWatchlistBloc;
    },
    act: (bloc) => bloc.add(GetListEvent()),
    expect: () =>
        [FilmWatchlistLoading(), FilmWatchlistLoaded(testWatchlistMovieList)],
    verify: (bloc) {
      verify(mockGetWatchlistMovies.execute());
    },
  );

  blocTest<FilmWatchlistBloc, FilmWatchlistState>(
    'Should emit [Loading, Error] when get watchlist is unsuccessful',
    build: () {
      when(mockGetWatchlistMovies.execute())
          .thenAnswer((_) async => const Left(ServerFailure("Can't get data")));
      return filmWatchlistBloc;
    },
    act: (bloc) => bloc.add(GetListEvent()),
    expect: () =>
        [FilmWatchlistLoading(), const FilmWatchlistError("Can't get data")],
    verify: (bloc) {
      verify(mockGetWatchlistMovies.execute());
    },
  );

  blocTest<FilmWatchlistBloc, FilmWatchlistState>(
    'Should emit [Loaded] when get status movie watchlist is successful',
    build: () {
      when(mockGetWatchListStatus.executeMovie(tFilmId))
          .thenAnswer((_) async => true);
      return filmWatchlistBloc;
    },
    act: (bloc) => bloc.add(const GetStatusMovieEvent(tFilmId)),
    expect: () => [const FilmWatchlistStatusLoaded(true)],
    verify: (bloc) {
      verify(mockGetWatchListStatus.executeMovie(tFilmId));
    },
  );

  blocTest<FilmWatchlistBloc, FilmWatchlistState>(
    'Should emit [Loaded] when get status tv watchlist is successful',
    build: () {
      when(mockGetWatchListStatus.executeTv(tFilmId))
          .thenAnswer((_) async => true);
      return filmWatchlistBloc;
    },
    act: (bloc) => bloc.add(const GetStatusTvEvent(tFilmId)),
    expect: () => [const FilmWatchlistStatusLoaded(true)],
    verify: (bloc) {
      verify(mockGetWatchListStatus.executeTv(tFilmId));
    },
  );

  blocTest<FilmWatchlistBloc, FilmWatchlistState>(
    'Should emit [success] when add movie item to watchlist is successful',
    build: () {
      when(mockSaveWatchlist.executeMovie(testMovieDetail))
          .thenAnswer((_) async => const Right("Success"));
      return filmWatchlistBloc;
    },
    act: (bloc) => bloc.add(const AddItemMovieEvent(testMovieDetail)),
    expect: () => [const FilmWatchlistSuccess("Success")],
    verify: (bloc) {
      verify(mockSaveWatchlist.executeMovie(testMovieDetail));
    },
  );

  blocTest<FilmWatchlistBloc, FilmWatchlistState>(
    'Should emit [Loaded] when add tv item to watchlist is successful',
    build: () {
      when(mockSaveWatchlist.executeTv(testTvDetail))
          .thenAnswer((_) async => const Right("Success"));
      return filmWatchlistBloc;
    },
    act: (bloc) => bloc.add(AddItemTvEvent(testTvDetail)),
    expect: () => [const FilmWatchlistSuccess("Success")],
    verify: (bloc) {
      verify(mockSaveWatchlist.executeTv(testTvDetail));
    },
  );

  blocTest<FilmWatchlistBloc, FilmWatchlistState>(
    'Should emit [success] when remove movie item to watchlist is successful',
    build: () {
      when(mockRemoveWatchlist.executeMovie(testMovieDetail))
          .thenAnswer((_) async => const Right("Removed"));
      return filmWatchlistBloc;
    },
    act: (bloc) => bloc.add(const RemoveItemMovieEvent(testMovieDetail)),
    expect: () => [const FilmWatchlistSuccess("Removed")],
    verify: (bloc) {
      verify(mockRemoveWatchlist.executeMovie(testMovieDetail));
    },
  );

  blocTest<FilmWatchlistBloc, FilmWatchlistState>(
    'Should emit [Loaded] when remove tv item to watchlist is successful',
    build: () {
      when(mockRemoveWatchlist.executeTv(testTvDetail))
          .thenAnswer((_) async => const Right("Removed"));
      return filmWatchlistBloc;
    },
    act: (bloc) => bloc.add(RemoveItemTvEvent(testTvDetail)),
    expect: () => [const FilmWatchlistSuccess("Removed")],
    verify: (bloc) {
      verify(mockRemoveWatchlist.executeTv(testTvDetail));
    },
  );

  blocTest<FilmWatchlistBloc, FilmWatchlistState>(
    'Should emit [error] when add movie item to watchlist is unsuccessful',
    build: () {
      when(mockSaveWatchlist.executeMovie(testMovieDetail))
          .thenAnswer((_) async => const Left(DatabaseFailure('Failed')));
      return filmWatchlistBloc;
    },
    act: (bloc) => bloc.add(const AddItemMovieEvent(testMovieDetail)),
    expect: () => [const FilmWatchlistError("Failed")],
    verify: (bloc) {
      verify(mockSaveWatchlist.executeMovie(testMovieDetail));
    },
  );

  blocTest<FilmWatchlistBloc, FilmWatchlistState>(
    'Should emit [error] when add tv item to watchlist is unsuccessful',
    build: () {
      when(mockSaveWatchlist.executeTv(testTvDetail))
          .thenAnswer((_) async => const Left(DatabaseFailure('Failed')));
      return filmWatchlistBloc;
    },
    act: (bloc) => bloc.add(AddItemTvEvent(testTvDetail)),
    expect: () => [const FilmWatchlistError("Failed")],
    verify: (bloc) {
      verify(mockSaveWatchlist.executeTv(testTvDetail));
    },
  );

  blocTest<FilmWatchlistBloc, FilmWatchlistState>(
    'Should emit [error] when remove movie item to watchlist is unsuccessful',
    build: () {
      when(mockRemoveWatchlist.executeMovie(testMovieDetail))
          .thenAnswer((_) async => const Left(DatabaseFailure('Failed')));
      return filmWatchlistBloc;
    },
    act: (bloc) => bloc.add(const RemoveItemMovieEvent(testMovieDetail)),
    expect: () => [const FilmWatchlistError("Failed")],
    verify: (bloc) {
      verify(mockRemoveWatchlist.executeMovie(testMovieDetail));
    },
  );

  blocTest<FilmWatchlistBloc, FilmWatchlistState>(
    'Should emit [error] when remove tv item to watchlist is unsuccessful',
    build: () {
      when(mockRemoveWatchlist.executeTv(testTvDetail))
          .thenAnswer((_) async => const Left(DatabaseFailure('Failed')));
      return filmWatchlistBloc;
    },
    act: (bloc) => bloc.add(RemoveItemTvEvent(testTvDetail)),
    expect: () => [const FilmWatchlistError("Failed")],
    verify: (bloc) {
      verify(mockRemoveWatchlist.executeTv(testTvDetail));
    },
  );
}
