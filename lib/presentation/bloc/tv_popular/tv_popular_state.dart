part of 'tv_popular_bloc.dart';

abstract class TvPopularState extends Equatable {
  const TvPopularState();

  @override
  List<Object> get props => [];
}

class TvPopularEmpty extends TvPopularState {}

class TvPopularLoading extends TvPopularState {}

class TvPopularError extends TvPopularState {
  final String message;

  const TvPopularError(this.message);

  @override
  List<Object> get props => [message];
}

class TvPopularLoaded extends TvPopularState {
  final List<Tv> result;

  const TvPopularLoaded(this.result);

  @override
  List<Object> get props => [result];
}

