import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_now_playing_tv.dart';
import 'package:equatable/equatable.dart';

part 'tv_now_playing_event.dart';
part 'tv_now_playing_state.dart';

class TvNowPlayingBloc extends Bloc<TvNowPlayingEvent, TvNowPlayingState> {
  final GetNowPlayingTv getNowPlayingTvs;

  TvNowPlayingBloc(
    this.getNowPlayingTvs,
  ) : super(TvNowPlayingEmpty()) {
    on<TvNowPlayingGetEvent>((event, emit) async {
      emit(TvNowPlayingLoading());
      final result = await getNowPlayingTvs.execute();

      result.fold(
        (failure) {
          emit(TvNowPlayingError(failure.message));
        },
        (data) {
          emit(TvNowPlayingLoaded(data));
        },
      );
    });
  }
}
