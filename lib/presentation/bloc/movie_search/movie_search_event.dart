part of 'movie_search_bloc.dart';

abstract class MovieSearchEvent extends Equatable {
  const MovieSearchEvent();

  @override
  List<Object> get props => [];
}

class MovieSearchSetEmpty extends MovieSearchEvent {}

class MovieSearchQueryEvent extends MovieSearchEvent {
  final String query;

  const MovieSearchQueryEvent(this.query);

  @override
  List<Object> get props => [];
}
