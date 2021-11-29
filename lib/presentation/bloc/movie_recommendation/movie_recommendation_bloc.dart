import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:equatable/equatable.dart';

part 'movie_recommendation_event.dart';
part 'movie_recommendation_state.dart';

class MovieRecommendationBloc
    extends Bloc<MovieRecommendationEvent, MovieRecommendationState> {
  final GetMovieRecommendations getMovieRecommendations;

  MovieRecommendationBloc({
    required this.getMovieRecommendations,
  }) : super(MovieRecommendationEmpty()) {
    on<GetMovieRecommendationEvent>((event, emit) async {
      final id = event.id;

      emit(MovieRecommendationLoading());
      final result = await getMovieRecommendations.execute(id);

      result.fold(
        (failure) {
          emit(MovieRecommendationError(failure.message));
        },
        (data) {
          emit(MovieRecommendationLoaded(data));
        },
      );
    });
  }
}
