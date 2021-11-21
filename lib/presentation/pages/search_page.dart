import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/provider/movie_search_notifier.dart';
import 'package:ditonton/presentation/provider/tv_search_notifier.dart';
import 'package:ditonton/presentation/widgets/film_card_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatelessWidget {
  static const routeName = '/search';
  final bool isMovie;

  const SearchPage({
    Key? key,
    required this.isMovie,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onSubmitted: (query) {
                if (isMovie) {
                  Provider.of<MovieSearchNotifier>(context, listen: false)
                      .fetchMovieSearch(query);
                } else {
                  Provider.of<TvSearchNotifier>(context, listen: false)
                      .fetchTvSearch(query);
                }
              },
              decoration: const InputDecoration(
                hintText: 'Search title',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.search,
            ),
            const SizedBox(height: 16),
            Text(
              'Search Result',
              style: kHeading6,
            ),
            if (isMovie) _consumerMovie(),
            if (!isMovie) _consumerTv(),
          ],
        ),
      ),
    );
  }

  Widget _consumerMovie() {
    return Consumer<MovieSearchNotifier>(
      builder: (context, data, child) {
        if (data.state == RequestState.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (data.state == RequestState.loaded) {
          final result = data.searchResult;
          return Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemBuilder: (context, index) {
                final movie = data.searchResult[index];
                return FilmCard(
                  id: movie.id,
                  posterPath: movie.posterPath.toString(),
                  title: movie.title ?? "-",
                  overview: movie.overview ?? "-",
                  isMovie: true,
                );
              },
              itemCount: result.length,
            ),
          );
        } else {
          return Expanded(
            child: Container(),
          );
        }
      },
    );
  }

  Widget _consumerTv() {
    return Consumer<TvSearchNotifier>(
      builder: (context, data, child) {
        if (data.state == RequestState.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (data.state == RequestState.loaded) {
          final result = data.searchResult;
          return Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemBuilder: (context, index) {
                final tv = data.searchResult[index];
                return FilmCard(
                  id: tv.id ?? 0,
                  posterPath: tv.posterPath.toString(),
                  title: tv.name ?? "-",
                  overview: tv.overview ?? "-",
                  isMovie: false,
                );
              },
              itemCount: result.length,
            ),
          );
        } else {
          return Expanded(
            child: Container(),
          );
        }
      },
    );
  }
}
