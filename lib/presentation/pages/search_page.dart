import 'package:ditonton/common/constants.dart';
import 'package:ditonton/presentation/bloc/movie_search/movie_search_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_search/tv_search_bloc.dart';
import 'package:ditonton/presentation/widgets/film_card_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  static const routeName = '/search';
  final bool isMovie;

  const SearchPage({
    Key? key,
    required this.isMovie,
  }) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  void initState() {
    widget.isMovie
        ? context.read<MovieSearchBloc>().add(MovieSearchSetEmpty())
        : context.read<TvSearchBloc>().add(TvSearchSetEmpty());
    super.initState();
  }

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
                if (widget.isMovie) {
                  context
                      .read<MovieSearchBloc>()
                      .add(MovieSearchQueryEvent(query));
                } else {
                  context.read<TvSearchBloc>().add(TvSearchQueryEvent(query));
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
            widget.isMovie ? _blocBuilderMovie() : _blocBuilderTv(),
          ],
        ),
      ),
    );
  }

  Widget _blocBuilderTv() {
    return BlocBuilder<TvSearchBloc, TvSearchState>(
      builder: (context, state) {
        print("state: $state");
        if (state is TvSearchLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is TvSearchLoaded) {
          final result = state.result;
          return Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemBuilder: (context, index) {
                final tv = result[index];
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
        } else if (state is TvSearchError) {
          return Expanded(
            child: Center(
              child: Text(state.message),
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

  Widget _blocBuilderMovie() {
    return BlocBuilder<MovieSearchBloc, MovieSearchState>(
      builder: (context, state) {
        print("state: $state");
        if (state is MovieSearchLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is MovieSearchLoaded) {
          final result = state.result;
          return Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemBuilder: (context, index) {
                final movie = result[index];
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
        } else if (state is MovieSearchError) {
          return Expanded(
            child: Center(
              child: Text(state.message),
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
