part of 'tv_episode_bloc.dart';

abstract class TvEpisodeState extends Equatable {
  const TvEpisodeState();

  @override
  List<Object> get props => [];
}

class TvEpisodeEmpty extends TvEpisodeState {}

class TvEpisodeLoading extends TvEpisodeState {}

class TvEpisodeError extends TvEpisodeState {
  final String message;

  const TvEpisodeError(this.message);

  @override
  List<Object> get props => [message];
}

class TvEpisodeLoaded extends TvEpisodeState {
  final List<Episode> result;

  const TvEpisodeLoaded(this.result);

  @override
  List<Object> get props => [result];
}
