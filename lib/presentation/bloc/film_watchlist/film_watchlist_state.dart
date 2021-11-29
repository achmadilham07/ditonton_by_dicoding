part of 'film_watchlist_bloc.dart';

abstract class FilmWatchlistState extends Equatable {
  const FilmWatchlistState();

  @override
  List<Object> get props => [];
}

class FilmWatchlistEmpty extends FilmWatchlistState {}

class FilmWatchlistLoading extends FilmWatchlistState {}

class FilmWatchlistError extends FilmWatchlistState {
  final String message;

  const FilmWatchlistError(this.message);

  @override
  List<Object> get props => [message];
}

class FilmWatchlistSuccess extends FilmWatchlistState {
  final String message;

  const FilmWatchlistSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class FilmWatchlistLoaded extends FilmWatchlistState {
  final List<Watchlist> result;

  const FilmWatchlistLoaded(this.result);

  @override
  List<Object> get props => [result];
}


class FilmWatchlistStatusLoaded extends FilmWatchlistState {
  final bool result;

  const FilmWatchlistStatusLoaded(this.result);

  @override
  List<Object> get props => [result];
}
