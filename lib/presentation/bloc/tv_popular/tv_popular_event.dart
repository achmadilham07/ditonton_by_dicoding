part of 'tv_popular_bloc.dart';

abstract class TvPopularEvent extends Equatable {
  const TvPopularEvent();

  @override
  List<Object> get props => [];
}

class TvPopularGetEvent extends TvPopularEvent {}
