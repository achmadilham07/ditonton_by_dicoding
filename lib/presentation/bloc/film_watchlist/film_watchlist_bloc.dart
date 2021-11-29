import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:ditonton/domain/entities/watchlist.dart';
import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'film_watchlist_event.dart';
part 'film_watchlist_state.dart';

class FilmWatchlistBloc extends Bloc<FilmWatchlistEvent, FilmWatchlistState> {
  
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetWatchlistMovies getFilmWatchlists;
  final GetWatchListStatus getWatchListStatus;
  final SaveWatchlist saveWatchlist;
  final RemoveWatchlist removeWatchlist;

  FilmWatchlistBloc({
    required this.getFilmWatchlists,
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  }) : super(FilmWatchlistEmpty()) {
    on<GetListEvent>((event, emit) async {
      emit(FilmWatchlistLoading());
      final result = await getFilmWatchlists.execute();

      result.fold(
        (failure) {
          emit(FilmWatchlistError(failure.message));
        },
        (data) {
          emit(FilmWatchlistLoaded(data));
        },
      );
    });

    on<GetStatusMovieEvent>((event, emit) async {
      final id = event.id;
      final result = await getWatchListStatus.executeMovie(id);

      emit(FilmWatchlistStatusLoaded(result));
    });

    on<GetStatusTvEvent>((event, emit) async {
      final id = event.id;
      final result = await getWatchListStatus.executeTv(id);

      emit(FilmWatchlistStatusLoaded(result));
    });

    on<AddItemMovieEvent>((event, emit) async {
      final movieDetail = event.movieDetail;
      final result = await saveWatchlist.executeMovie(movieDetail);

      result.fold(
        (failure) {
          emit(FilmWatchlistError(failure.message));
        },
        (successMessage) {
          emit(FilmWatchlistSuccess(successMessage));
        },
      );
    });

    on<AddItemTvEvent>((event, emit) async {
      final tvDetail = event.tvDetail;
      final result = await saveWatchlist.executeTv(tvDetail);

      result.fold(
        (failure) {
          emit(FilmWatchlistError(failure.message));
        },
        (successMessage) {
          emit(FilmWatchlistSuccess(successMessage));
        },
      );
    });

    on<RemoveItemMovieEvent>((event, emit) async {
      final movieDetail = event.movieDetail;
      final result = await removeWatchlist.executeMovie(movieDetail);

      result.fold(
        (failure) {
          emit(FilmWatchlistError(failure.message));
        },
        (successMessage) {
          emit(FilmWatchlistSuccess(successMessage));
        },
      );
    });

    on<RemoveItemTvEvent>((event, emit) async {
      final tvDetail = event.tvDetail;
      final result = await removeWatchlist.executeTv(tvDetail);

      result.fold(
        (failure) {
          emit(FilmWatchlistError(failure.message));
        },
        (successMessage) {
          emit(FilmWatchlistSuccess(successMessage));
        },
      );
    });
  }
}
