part of 'tv_now_playing_bloc.dart';

abstract class TvNowPlayingEvent extends Equatable {
  const TvNowPlayingEvent();

  @override
  List<Object> get props => [];
}

class TvNowPlayingGetEvent extends TvNowPlayingEvent {}
