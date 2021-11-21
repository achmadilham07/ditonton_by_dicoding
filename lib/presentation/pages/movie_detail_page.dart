import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/data/models/episode_response.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/presentation/pages/home_page.dart';
import 'package:ditonton/presentation/provider/movie_detail_notifier.dart';
import 'package:ditonton/presentation/provider/tv_detail_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class FilmDetailArgs {
  final int id;
  final bool isMovie;

  FilmDetailArgs({
    required this.id,
    required this.isMovie,
  });
}

class FilmDetailPage extends StatefulWidget {
  static const routeName = '/detail';

  final FilmDetailArgs args;

  const FilmDetailPage({
    Key? key,
    required this.args,
  }) : super(key: key);

  @override
  _FilmDetailPageState createState() => _FilmDetailPageState();
}

class _FilmDetailPageState extends State<FilmDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (widget.args.isMovie) {
        Provider.of<MovieDetailNotifier>(context, listen: false)
          ..fetchMovieDetail(widget.args.id)
          ..loadWatchlistStatus(widget.args.id);
      } else {
        Provider.of<TvDetailNotifier>(context, listen: false)
          ..fetchTvDetail(widget.args.id)
          ..loadWatchlistStatus(widget.args.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.args.isMovie ? _movieConsumer() : _tvConsumer(),
    );
  }

  Widget _tvConsumer() {
    return Consumer<TvDetailNotifier>(
      builder: (context, provider, child) {
        if (provider.tvState == RequestState.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (provider.tvState == RequestState.loaded) {
          final tv = provider.tv;
          final seasons = tv.seasons;
          final tvEpisode = provider.tvEpisode;
          final isAddedWatchlist = provider.isAddedToWatchlist;
          return SafeArea(
            child: DetailContent(
              isAddedWatchlist: isAddedWatchlist,
              voteAverage: tv.voteAverage ?? 0,
              title: tv.name.toString(),
              runtime: tv.episodeRunTime?.first ?? 0,
              overview: tv.overview.toString(),
              imageUrl: 'https://image.tmdb.org/t/p/w500${tv.posterPath}',
              genres: tv.genres ?? [],
              onWatchListClick: () async {
                if (!isAddedWatchlist) {
                  await Provider.of<TvDetailNotifier>(context, listen: false)
                      .addWatchlist(tv);
                } else {
                  await Provider.of<TvDetailNotifier>(context, listen: false)
                      .removeFromWatchlist(tv);
                }

                final message =
                    Provider.of<TvDetailNotifier>(context, listen: false)
                        .watchlistMessage;

                if (message == TvDetailNotifier.watchlistAddSuccessMessage ||
                    message == TvDetailNotifier.watchlistRemoveSuccessMessage) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(message)));
                } else {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: Text(message),
                        );
                      });
                }
              },
              lwEpisode: [
                Selector<TvDetailNotifier, List<Episode>>(
                  selector: (_, data) => data.tvEpisode,
                  builder: (_, value, __) {
                    if (provider.episodeState == RequestState.loading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (provider.episodeState == RequestState.loaded) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 16),
                          Text(
                            'Episode',
                            style: kHeading6,
                          ),
                          SizedBox(
                            height: 90,
                            child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: tvEpisode.length,
                              itemBuilder: (context, index) {
                                final item = tvEpisode[index];
                                final episode = item.name;
                                return Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        constraints: const BoxConstraints(
                                            maxWidth: 160, minWidth: 160),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Episode ${index + 1}",
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Text(
                                              "\"$episode\"",
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 16),
                          Text(
                            'Episode',
                            style: kHeading6,
                          ),
                          const Text("No episode"),
                        ],
                      );
                    }
                  },
                ),
              ],
              lwSeason: seasons?.isEmpty ?? true
                  ? [Container()]
                  : [
                      const SizedBox(height: 16),
                      Text(
                        'Seasons',
                        style: kHeading6,
                      ),
                      SizedBox(
                        height: 90,
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: seasons!.length,
                          itemBuilder: (context, index) {
                            final item = seasons[index];
                            String overview =
                                (item.overview?.isNotEmpty ?? false)
                                    ? item.overview.toString()
                                    : "-";
                            return Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Card(
                                child: InkWell(
                                  onTap: () async {
                                    await Provider.of<TvDetailNotifier>(context,
                                            listen: false)
                                        .fetchTvEpisode(tv.id!, index);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      constraints: const BoxConstraints(
                                          maxWidth: 160, minWidth: 160),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Season ${index + 1}",
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w600),
                                          ),
                                          Text(
                                            "\"$overview\"",
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    ],
              lwRecommendations: [
                const SizedBox(height: 16),
                Text(
                  'Recommendations',
                  style: kHeading6,
                ),
                Builder(builder: (context) {
                  if (provider.recommendationState == RequestState.loading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (provider.recommendationState ==
                      RequestState.error) {
                    return Text(provider.message);
                  } else if (provider.recommendationState ==
                      RequestState.loaded) {
                    final recommendations = provider.tvRecommendations;
                    if (recommendations.isEmpty) {
                      return const Text("No recommendations");
                    }
                    return SizedBox(
                      height: 150,
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: recommendations.length,
                        itemBuilder: (context, index) {
                          final tv = recommendations[index];
                          return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: HomeItem(
                              imageUrl:
                                  'https://image.tmdb.org/t/p/w500${tv.posterPath}',
                              onClick: () {
                                Navigator.pushReplacementNamed(
                                  context,
                                  FilmDetailPage.routeName,
                                  arguments: FilmDetailArgs(
                                      id: tv.id ?? 0, isMovie: false),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    );
                  } else {
                    return const Text("No recommendations");
                  }
                }),
              ],
            ),
          );
        } else {
          return Text(provider.message);
        }
      },
    );
  }

  Widget _movieConsumer() {
    return Consumer<MovieDetailNotifier>(
      builder: (context, provider, child) {
        if (provider.movieState == RequestState.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (provider.movieState == RequestState.loaded) {
          final movie = provider.movie;
          final isAddedWatchlist = provider.isAddedToWatchlist;
          return SafeArea(
            child: DetailContent(
              isAddedWatchlist: isAddedWatchlist,
              voteAverage: movie.voteAverage,
              title: movie.title.toString(),
              runtime: movie.runtime,
              overview: movie.overview,
              imageUrl: 'https://image.tmdb.org/t/p/w500${movie.posterPath}',
              genres: movie.genres,
              onWatchListClick: () async {
                if (!isAddedWatchlist) {
                  await Provider.of<MovieDetailNotifier>(context, listen: false)
                      .addWatchlist(movie);
                } else {
                  await Provider.of<MovieDetailNotifier>(context, listen: false)
                      .removeFromWatchlist(movie);
                }

                final message =
                    Provider.of<MovieDetailNotifier>(context, listen: false)
                        .watchlistMessage;

                if (message == MovieDetailNotifier.watchlistAddSuccessMessage ||
                    message ==
                        MovieDetailNotifier.watchlistRemoveSuccessMessage) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(message)));
                } else {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: Text(message),
                        );
                      });
                }
              },
              lwSeason: [Container()],
              lwEpisode: [Container()],
              lwRecommendations: [
                const SizedBox(height: 16),
                Text(
                  'Recommendations',
                  style: kHeading6,
                ),
                Builder(builder: (context) {
                  if (provider.recommendationState == RequestState.loading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (provider.recommendationState ==
                      RequestState.error) {
                    return Text(provider.message);
                  } else if (provider.recommendationState ==
                      RequestState.loaded) {
                    final recommendations = provider.movieRecommendations;
                    if (recommendations.isEmpty) {
                      return const Text("No recommendations");
                    }
                    return SizedBox(
                      height: 150,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          final movie = recommendations[index];
                          return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: HomeItem(
                              imageUrl:
                                  'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                              onClick: () {
                                Navigator.pushReplacementNamed(
                                  context,
                                  FilmDetailPage.routeName,
                                  arguments: FilmDetailArgs(
                                      id: movie.id, isMovie: true),
                                );
                              },
                            ),
                          );
                        },
                        itemCount: recommendations.length,
                      ),
                    );
                  } else {
                    return const Text("No recommendations");
                  }
                }),
              ],
            ),
          );
        } else {
          return Text(provider.message);
        }
      },
    );
  }
}

class DetailContent extends StatelessWidget {
  final String imageUrl;
  final String title;
  final VoidCallback onWatchListClick;
  final List<Genre> genres;
  final int runtime;
  final double voteAverage;
  final String overview;
  final List<Widget> lwRecommendations;
  final List<Widget> lwSeason;
  final List<Widget> lwEpisode;
  final bool isAddedWatchlist;

  const DetailContent({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.onWatchListClick,
    required this.genres,
    required this.runtime,
    required this.voteAverage,
    required this.overview,
    required this.lwRecommendations,
    required this.isAddedWatchlist,
    required this.lwSeason,
    required this.lwEpisode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: imageUrl,
          width: screenWidth,
          placeholder: (context, url) => const Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: kRichBlack,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                padding: const EdgeInsets.only(
                  left: 16,
                  top: 16,
                  right: 16,
                ),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: kHeading5,
                            ),
                            ElevatedButton(
                              onPressed: onWatchListClick,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  isAddedWatchlist
                                      ? const Icon(Icons.check)
                                      : const Icon(Icons.add),
                                  const Text('Watchlist'),
                                ],
                              ),
                            ),
                            Text(
                              _showGenres(genres),
                            ),
                            Text(
                              _showDuration(runtime),
                            ),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => const Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('$voteAverage')
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Overview',
                              style: kHeading6,
                            ),
                            Text(
                              overview,
                            ),
                            ...lwSeason,
                            ...lwEpisode,
                            ...lwRecommendations,
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        color: Colors.white,
                        height: 4,
                        width: 48,
                      ),
                    ),
                  ],
                ),
              );
            },
            // initialChildSize: 0.5,
            minChildSize: 0.25,
            // maxChildSize: 1.0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: kRichBlack,
            foregroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        )
      ],
    );
  }

  String _showGenres(List<Genre> genres) {
    String result = '';
    for (var genre in genres) {
      result += genre.name + ', ';
    }

    if (result.isEmpty) {
      return result;
    }

    return result.substring(0, result.length - 2);
  }

  String _showDuration(int runtime) {
    final int hours = runtime ~/ 60;
    final int minutes = runtime % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }
}
