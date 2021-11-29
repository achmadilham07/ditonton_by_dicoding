part of 'tv_recommendation_bloc.dart';

abstract class TvRecommendationEvent extends Equatable {
  const TvRecommendationEvent();

  @override
  List<Object> get props => [];
}

class GetTvRecommendationEvent extends TvRecommendationEvent {
  final int id;

  const GetTvRecommendationEvent(this.id);

  @override
  List<Object> get props => [];
}
