import 'package:ditonton/domain/usecases/search_movies.dart';
import 'package:equatable/equatable.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'movie_search_event.dart';
part 'movie_search_state.dart';

class MovieSearchBloc extends Bloc<MovieSearchEvent, MovieSearchState> {
  final SearchMovies searchMovies;
  MovieSearchBloc({
    required this.searchMovies,
  }) : super(MovieSearchEmpty()) {
    on<MovieSearchQueryEvent>((event, emit) async {
      final query = event.query;

      emit(MovieSearchLoading());
      final result = await searchMovies.execute(query);

      result.fold(
        (failure) {
          emit(MovieSearchError(failure.message));
        },
        (data) {
          emit(MovieSearchLoaded(data));
        },
      );
    });
  }
}
