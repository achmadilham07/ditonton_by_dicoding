part of 'tv_now_playing_bloc.dart';

abstract class TvNowPlayingState extends Equatable {
  const TvNowPlayingState();

  @override
  List<Object> get props => [];
}

class TvNowPlayingEmpty extends TvNowPlayingState {}

class TvNowPlayingLoading extends TvNowPlayingState {}

class TvNowPlayingError extends TvNowPlayingState {
  final String message;

  const TvNowPlayingError(this.message);

  @override
  List<Object> get props => [message];
}

class TvNowPlayingLoaded extends TvNowPlayingState {
  final List<Tv> result;

  const TvNowPlayingLoaded(this.result);

  @override
  List<Object> get props => [result];
}

