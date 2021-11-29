import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_tv_recommendation.dart';
import 'package:equatable/equatable.dart';

part 'tv_recommendation_event.dart';
part 'tv_recommendation_state.dart';

class TvRecommendationBloc
    extends Bloc<TvRecommendationEvent, TvRecommendationState> {
  final GetTvRecommendation getTvRecommendations;

  TvRecommendationBloc({
    required this.getTvRecommendations,
  }) : super(TvRecommendationEmpty()) {
    on<GetTvRecommendationEvent>((event, emit) async {
      final id = event.id;

      emit(TvRecommendationLoading());
      final result = await getTvRecommendations.execute(id);

      result.fold(
        (failure) {
          emit(TvRecommendationError(failure.message));
        },
        (data) {
          emit(TvRecommendationLoaded(data));
        },
      );
    });
  }
}
