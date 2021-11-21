import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/data/models/episode_response.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_episode.dart';
import 'package:ditonton/domain/usecases/get_tv_recommendation.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TvDetailNotifier extends ChangeNotifier {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetTvEpisode getTvEpisode;
  final GetTvDetail getTvDetail;
  final GetTvRecommendation getTvRecommendations;
  final GetWatchListStatus getWatchListStatus;
  final SaveWatchlist saveWatchlist;
  final RemoveWatchlist removeWatchlist;

  TvDetailNotifier({
    required this.getTvEpisode,
    required this.getTvDetail,
    required this.getTvRecommendations,
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  });

  late TvDetail _tv;

  TvDetail get tv => _tv;

  RequestState _tvState = RequestState.empty;

  RequestState get tvState => _tvState;

  List<Tv> _tvRecommendations = [];

  List<Tv> get tvRecommendations => _tvRecommendations;

  RequestState _recommendationState = RequestState.empty;

  RequestState get recommendationState => _recommendationState;

  List<Episode> _tvEpisode = [];

  List<Episode> get tvEpisode => _tvEpisode;

  RequestState _episodeState = RequestState.empty;

  RequestState get episodeState => _episodeState;

  String _message = '';

  String get message => _message;

  bool _isAddedtoWatchlist = false;

  bool get isAddedToWatchlist => _isAddedtoWatchlist;

  String _watchlistMessage = '';

  String get watchlistMessage => _watchlistMessage;

  Future<void> fetchTvDetail(int id) async {
    _tvState = RequestState.loading;
    notifyListeners();
    final detailResult = await getTvDetail.execute(id);
    final recommendationResult = await getTvRecommendations.execute(id);
    final episodeResult = await getTvEpisode.execute(id, 1);

    detailResult.fold(
      (failure) {
        _tvState = RequestState.error;
        _message = failure.message;
        notifyListeners();
      },
      (tv) async {
        _recommendationState = RequestState.loading;
        _tv = tv;
        notifyListeners();

        recommendationResult.fold(
          (failure) {
            _recommendationState = RequestState.error;
            _message = failure.message;
          },
          (tvs) {
            _recommendationState = RequestState.loaded;
            _tvRecommendations = tvs;

            episodeResult.fold(
              (l) {
                _episodeState = RequestState.error;
                _message = l.message;
                notifyListeners();
              },
              (r) {
                _episodeState = RequestState.loaded;
                _tvEpisode = r;
                notifyListeners();
              },
            );
          },
        );
        _tvState = RequestState.loaded;
        notifyListeners();
      },
    );
  }

  Future fetchTvEpisode(int idTv, int idSeason) async {
    _episodeState = RequestState.loading;
    notifyListeners();
    final episodeResult = await getTvEpisode.execute(idTv, idSeason);

    episodeResult.fold(
      (l) {
        _episodeState = RequestState.error;
        _message = l.message;
        notifyListeners();
      },
      (r) {
        _episodeState = RequestState.loaded;
        _tvEpisode = r;
        notifyListeners();
      },
    );
  }

  Future<void> addWatchlist(TvDetail tv) async {
    final result = await saveWatchlist.executeTv(tv);

    await result.fold(
      (failure) async {
        _watchlistMessage = failure.message;
      },
      (successMessage) async {
        _watchlistMessage = successMessage;
      },
    );

    await loadWatchlistStatus(tv.id);
  }

  Future<void> removeFromWatchlist(TvDetail tv) async {
    final result = await removeWatchlist.executeTv(tv);

    await result.fold(
      (failure) async {
        _watchlistMessage = failure.message;
      },
      (successMessage) async {
        _watchlistMessage = successMessage;
      },
    );

    await loadWatchlistStatus(tv.id);
  }

  Future<void> loadWatchlistStatus(int? id) async {
    final result = await getWatchListStatus.executeTv(id ?? 0);
    _isAddedtoWatchlist = result;
    notifyListeners();
  }
}
