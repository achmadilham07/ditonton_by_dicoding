import 'package:ditonton/presentation/bloc/tv_popular/tv_popular_bloc.dart';
import 'package:ditonton/presentation/widgets/film_card_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class PopularTvsPage extends StatefulWidget {
  static const routeName = '/popular-tv';

  const PopularTvsPage({Key? key}) : super(key: key);

  @override
  _PopularTvsPageState createState() => _PopularTvsPageState();
}

class _PopularTvsPageState extends State<PopularTvsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<TvPopularBloc>().add(TvPopularGetEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Popular Tvs'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TvPopularBloc, TvPopularState>(
          builder: (context, state) {
            if (state is TvPopularLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is TvPopularLoaded) {
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
            } else if (state is TvPopularError) {
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
