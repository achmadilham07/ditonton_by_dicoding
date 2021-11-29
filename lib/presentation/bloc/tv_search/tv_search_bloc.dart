import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/search_tv.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'tv_search_event.dart';
part 'tv_search_state.dart';

class TvSearchBloc extends Bloc<TvSearchEvent, TvSearchState> {
  final SearchTv searchTvs;
  TvSearchBloc({
    required this.searchTvs,
  }) : super(TvSearchEmpty()) {
    on<TvSearchQueryEvent>((event, emit) async {
      final query = event.query;

      emit(TvSearchLoading());
      final result = await searchTvs.execute(query);

      result.fold(
        (failure) {
          emit(TvSearchError(failure.message));
        },
        (data) {
          emit(TvSearchLoaded(data));
        },
      );
    });
  }
}
