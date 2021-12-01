part of 'tv_search_bloc.dart';

abstract class TvSearchEvent extends Equatable {
  const TvSearchEvent();

  @override
  List<Object> get props => [];
}

class TvSearchSetEmpty extends TvSearchEvent {}

class TvSearchQueryEvent extends TvSearchEvent {
  final String query;

  const TvSearchQueryEvent(this.query);

  @override
  List<Object> get props => [];
}
