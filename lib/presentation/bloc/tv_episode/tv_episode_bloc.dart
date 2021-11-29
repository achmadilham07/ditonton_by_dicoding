import 'package:bloc/bloc.dart';
import 'package:ditonton/data/models/episode_response.dart';
import 'package:ditonton/domain/usecases/get_tv_episode.dart';
import 'package:equatable/equatable.dart';

part 'tv_episode_event.dart';
part 'tv_episode_state.dart';

class TvEpisodeBloc extends Bloc<TvEpisodeEvent, TvEpisodeState> {
  final GetTvEpisode getTvEpisode;

  TvEpisodeBloc(
    this.getTvEpisode,
  ) : super(TvEpisodeEmpty()) {
    on<TvEpisodeGetEvent>((event, emit) async {
      final idTv = event.idTv;
      final idEpisode = event.idEpisode;
      
      emit(TvEpisodeLoading());
      final result = await getTvEpisode.execute(idTv, idEpisode);

      result.fold(
        (failure) {
          emit(TvEpisodeError(failure.message));
        },
        (data) {
          emit(TvEpisodeLoaded(data));
        },
      );
    });
  }
}
