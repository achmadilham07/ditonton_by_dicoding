part of 'film_watchlist_bloc.dart';

abstract class FilmWatchlistEvent extends Equatable {
  const FilmWatchlistEvent();

  @override
  List<Object> get props => [];
}

class GetListEvent extends FilmWatchlistEvent {}

class GetStatusMovieEvent extends FilmWatchlistEvent {
  final int id;

  const GetStatusMovieEvent(this.id);

  @override
  List<Object> get props => [id];
}

class GetStatusTvEvent extends FilmWatchlistEvent {
  final int id;

  const GetStatusTvEvent(this.id);

  @override
  List<Object> get props => [id];
}

class AddItemMovieEvent extends FilmWatchlistEvent {
  final MovieDetail movieDetail;

  const AddItemMovieEvent(this.movieDetail);

  @override
  List<Object> get props => [movieDetail];
}

class AddItemTvEvent extends FilmWatchlistEvent {
  final TvDetail tvDetail;

  const AddItemTvEvent(this.tvDetail);

  @override
  List<Object> get props => [tvDetail];
}

class RemoveItemMovieEvent extends FilmWatchlistEvent {
  final MovieDetail movieDetail;

  const RemoveItemMovieEvent(this.movieDetail);

  @override
  List<Object> get props => [movieDetail];
}

class RemoveItemTvEvent extends FilmWatchlistEvent {
  final TvDetail tvDetail;

  const RemoveItemTvEvent(this.tvDetail);

  @override
  List<Object> get props => [tvDetail];
}
