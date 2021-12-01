part of 'tv_episode_bloc.dart';

abstract class TvEpisodeEvent extends Equatable {
  const TvEpisodeEvent();

  @override
  List<Object> get props => [];
}

class TvEpisodeGetEvent extends TvEpisodeEvent {
  final int idTv;
  final int idEpisode;

  const TvEpisodeGetEvent(this.idTv, this.idEpisode);

  @override
  List<Object> get props => [idTv, idEpisode];
}
