import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:equatable/equatable.dart';

part 'movie_popular_event.dart';
part 'movie_popular_state.dart';

class MoviePopularBloc extends Bloc<MoviePopularEvent, MoviePopularState> {
  final GetPopularMovies getMoviePopulars;

  MoviePopularBloc(
    this.getMoviePopulars,
  ) : super(MoviePopularEmpty()) {
    on<MoviePopularGetEvent>((event, emit) async {
      emit(MoviePopularLoading());
      final result = await getMoviePopulars.execute();

      result.fold(
        (failure) {
          emit(MoviePopularError(failure.message));
        },
        (data) {
          emit(MoviePopularLoaded(data));
        },
      );
    });
  }
}
