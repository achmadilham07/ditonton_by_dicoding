import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/presentation/bloc/movie_top_rated/movie_top_rated_bloc.dart';
import 'package:ditonton/presentation/provider/top_rated_movies_notifier.dart';
import 'package:ditonton/presentation/widgets/film_card_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class TopRatedMoviesPage extends StatefulWidget {
  static const routeName = '/top-rated-movie';

  const TopRatedMoviesPage({Key? key}) : super(key: key);

  @override
  _TopRatedMoviesPageState createState() => _TopRatedMoviesPageState();
}

class _TopRatedMoviesPageState extends State<TopRatedMoviesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (isProvider) {
        context.read<TopRatedMoviesNotifier>().fetchTopRatedMovies();
      } else {
        context.read<MovieTopRatedBloc>().add(MovieTopRatedGetEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Rated Movies'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: isProvider
            ? Consumer<TopRatedMoviesNotifier>(
                builder: (context, data, child) {
                  if (data.state == RequestState.loading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (data.state == RequestState.loaded) {
                    return ListView.builder(
                      itemBuilder: (context, index) {
                        final movie = data.movies[index];
                        return FilmCard(
                          id: movie.id,
                          posterPath: movie.posterPath.toString(),
                          title: movie.title ?? "-",
                          overview: movie.overview ?? "-",
                          isMovie: true,
                        );
                      },
                      itemCount: data.movies.length,
                    );
                  } else {
                    return Center(
                      key: const Key('error_message'),
                      child: Text(data.message),
                    );
                  }
                },
              )
            : BlocBuilder<MovieTopRatedBloc, MovieTopRatedState>(
                builder: (context, state) {
                  if (state is MovieTopRatedLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is MovieTopRatedLoaded) {
                    return ListView.builder(
                      itemBuilder: (context, index) {
                        final movie = state.result[index];
                        return FilmCard(
                          id: movie.id,
                          posterPath: movie.posterPath.toString(),
                          title: movie.title ?? "-",
                          overview: movie.overview ?? "-",
                          isMovie: true,
                        );
                      },
                      itemCount: state.result.length,
                    );
                  } else if (state is MovieTopRatedError) {
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
}
