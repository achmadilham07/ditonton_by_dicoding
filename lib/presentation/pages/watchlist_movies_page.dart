import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/utils.dart';
import 'package:ditonton/domain/entities/watchlist.dart';
import 'package:ditonton/presentation/bloc/film_watchlist/film_watchlist_bloc.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class WatchlistMoviesPage extends StatefulWidget {
  static const routeName = '/watchlist-movie';

  const WatchlistMoviesPage({Key? key}) : super(key: key);

  @override
  _WatchlistMoviesPageState createState() => _WatchlistMoviesPageState();
}

class _WatchlistMoviesPageState extends State<WatchlistMoviesPage>
    with RouteAware {
  @override
  void initState() {
    super.initState();
    _loadWatchlist();
  }

  @override
  void didChangeDependencies() {
    routeObserver.subscribe(this, ModalRoute.of(context)!);
    super.didChangeDependencies();
  }

  @override
  void didPopNext() {
    _loadWatchlist();
    super.didPopNext();
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Watchlist'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<FilmWatchlistBloc, FilmWatchlistState>(
          builder: (context, state) {
            if (state is FilmWatchlistLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is FilmWatchlistLoaded) {
              return _listTabWidget(state.result);
            } else if (state is FilmWatchlistError) {
              return Center(
                key: const Key('error_message'),
                child: Text(state.message),
              );
            } else {
              return const Center(
                key: Key('error_message'),
                child: Text("Error"),
              );
            }
          },
        ),
      ),
    );
  }

  Future _loadWatchlist() => Future.microtask(() {
        context.read<FilmWatchlistBloc>().add(GetListEvent());
      });

  Widget _listTabWidget(List<Watchlist> result) {
    final movieList =
        result.where((element) => element.isMovie ?? false).toList();
    final tvList =
        result.where((element) => !(element.isMovie ?? false)).toList();
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(text: "Movie"),
              Tab(text: "Tv Show"),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _listWidget(movieList),
                _listWidget(tvList),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _listWidget(List<Watchlist> list) {
    return ListView.builder(
      key: ObjectKey(list),
      itemBuilder: (context, index) {
        final item = list[index];
        return WatchlistCard(item);
      },
      itemCount: list.length,
    );
  }
}

class WatchlistCard extends StatelessWidget {
  final Watchlist movie;

  const WatchlistCard(this.movie, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            FilmDetailPage.routeName,
            arguments:
                FilmDetailArgs(id: movie.id, isMovie: movie.isMovie ?? false),
          );
        },
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            Card(
              child: Container(
                margin: const EdgeInsets.only(
                  left: 16 + 80 + 16,
                  bottom: 8,
                  right: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title ?? '-',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: kHeading6,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      movie.overview ?? '-',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                left: 16,
                bottom: 16,
              ),
              child: ClipRRect(
                child: CachedNetworkImage(
                  imageUrl: '$baseImageUrl${movie.posterPath}',
                  width: 80,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
                borderRadius: const BorderRadius.all(Radius.circular(8)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
