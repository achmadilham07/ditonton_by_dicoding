import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_popular_tv.dart';
import 'package:equatable/equatable.dart';

part 'tv_popular_event.dart';
part 'tv_popular_state.dart';

class TvPopularBloc extends Bloc<TvPopularEvent, TvPopularState> {
  final GetPopularTv getTvPopulars;

  TvPopularBloc(
    this.getTvPopulars,
  ) : super(TvPopularEmpty()) {
    on<TvPopularGetEvent>((event, emit) async {
      emit(TvPopularLoading());
      final result = await getTvPopulars.execute();

      result.fold(
        (failure) {
          emit(TvPopularError(failure.message));
        },
        (data) {
          emit(TvPopularLoaded(data));
        },
      );
    });
  }
}
