import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/presentation/bloc/tv_top_rated/tv_top_rated_bloc.dart';
import 'package:ditonton/presentation/provider/top_rated_tv_notifier.dart';
import 'package:ditonton/presentation/widgets/film_card_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class TopRatedTvsPage extends StatefulWidget {
  static const routeName = '/top-rated-tv';

  const TopRatedTvsPage({Key? key}) : super(key: key);

  @override
  _TopRatedTvsPageState createState() => _TopRatedTvsPageState();
}

class _TopRatedTvsPageState extends State<TopRatedTvsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (isProvider) {
        context.read<TopRatedTvsNotifier>().fetchTopRatedTvs();
      } else {
        context.read<TvTopRatedBloc>().add(TvTopRatedGetEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Rated Tvs'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: isProvider
            ? Consumer<TopRatedTvsNotifier>(
                builder: (context, data, child) {
                  if (data.state == RequestState.loading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (data.state == RequestState.loaded) {
                    return ListView.builder(
                      itemBuilder: (context, index) {
                        final tv = data.tvs[index];
                        return FilmCard(
                          id: tv.id ?? 0,
                          posterPath: tv.posterPath.toString(),
                          title: tv.name ?? "-",
                          overview: tv.overview ?? "-",
                          isMovie: false,
                        );
                      },
                      itemCount: data.tvs.length,
                    );
                  } else {
                    return Center(
                      key: const Key('error_message'),
                      child: Text(data.message),
                    );
                  }
                },
              )
            : BlocBuilder<TvTopRatedBloc, TvTopRatedState>(
                builder: (context, state) {
                  if (state is TvTopRatedLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is TvTopRatedLoaded) {
                    return ListView.builder(
                      itemBuilder: (context, index) {
                        final tv = state.result[index];
                        return FilmCard(
                          id: tv.id ?? 0,
                          posterPath: tv.posterPath.toString(),
                          title: tv.name ?? "-",
                          overview: tv.overview ?? "-",
                          isMovie: false,
                        );
                      },
                      itemCount: state.result.length,
                    );
                  } else if (state is TvTopRatedError) {
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
