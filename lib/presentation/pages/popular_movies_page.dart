import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/presentation/bloc/movie_popular/movie_popular_bloc.dart';
import 'package:ditonton/presentation/provider/popular_movies_notifier.dart';
import 'package:ditonton/presentation/widgets/film_card_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class PopularMoviesPage extends StatefulWidget {
  static const routeName = '/popular-movie';

  const PopularMoviesPage({Key? key}) : super(key: key);

  @override
  _PopularMoviesPageState createState() => _PopularMoviesPageState();
}

class _PopularMoviesPageState extends State<PopularMoviesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (isProvider) {
        context.read<PopularMoviesNotifier>().fetchPopularMovies();
      } else {
        context.read<MoviePopularBloc>().add(MoviePopularGetEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Popular Movies'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: isProvider
            ? Consumer<PopularMoviesNotifier>(
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
            : BlocBuilder<MoviePopularBloc, MoviePopularState>(
                builder: (context, state) {
                  if (state is MoviePopularLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is MoviePopularLoaded) {
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
                  } else if (state is MoviePopularError) {
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
