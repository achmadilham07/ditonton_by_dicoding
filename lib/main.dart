import 'package:ditonton/common/constants.dart';
import 'package:ditonton/injection.dart' as di;
import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:ditonton/presentation/pages/home_page.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:ditonton/presentation/pages/popular_movies_page.dart';
import 'package:ditonton/presentation/pages/popular_tv_page.dart';
import 'package:ditonton/presentation/pages/search_page.dart';
import 'package:ditonton/presentation/pages/top_rated_movies_page.dart';
import 'package:ditonton/presentation/pages/top_rated_tv_page.dart';
import 'package:ditonton/presentation/pages/watchlist_movies_page.dart';
import 'package:ditonton/presentation/provider/movie_detail_notifier.dart';
import 'package:ditonton/presentation/provider/movie_list_notifier.dart';
import 'package:ditonton/presentation/provider/movie_search_notifier.dart';
import 'package:ditonton/presentation/provider/popular_movies_notifier.dart';
import 'package:ditonton/presentation/provider/popular_tv_notifier.dart';
import 'package:ditonton/presentation/provider/top_rated_movies_notifier.dart';
import 'package:ditonton/presentation/provider/top_rated_tv_notifier.dart';
import 'package:ditonton/presentation/provider/tv_detail_notifier.dart';
import 'package:ditonton/presentation/provider/tv_list_notifier.dart';
import 'package:ditonton/presentation/provider/tv_search_notifier.dart';
import 'package:ditonton/presentation/provider/watchlist_movie_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => di.locator<MovieListNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<MovieDetailNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<MovieSearchNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<TopRatedMoviesNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<PopularMoviesNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<WatchlistMovieNotifier>(),
        ),

        /// tv
        ChangeNotifierProvider(
          create: (_) => di.locator<TvListNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<TvDetailNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<TvSearchNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<TopRatedTvsNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<PopularTvsNotifier>(),
        ),
      ],
      child: MaterialApp(
        title: 'Ditonton',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          colorScheme: kColorScheme.copyWith(secondary: kMikadoYellow),
          primaryColor: kRichBlack,
          scaffoldBackgroundColor: kRichBlack,
          textTheme: kTextTheme,
        ),
        home: const HomePage(),
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case '/home':
              return MaterialPageRoute(
                builder: (_) => const HomePage(),
                settings: settings,
              );
            case PopularMoviesPage.routeName:
              return CupertinoPageRoute(
                builder: (_) => const PopularMoviesPage(),
                settings: settings,
              );
            case PopularTvsPage.routeName:
              return CupertinoPageRoute(
                builder: (_) => const PopularTvsPage(),
                settings: settings,
              );
            case TopRatedMoviesPage.routeName:
              return CupertinoPageRoute(
                builder: (_) => const TopRatedMoviesPage(),
                settings: settings,
              );
            case TopRatedTvsPage.routeName:
              return CupertinoPageRoute(
                builder: (_) => const TopRatedTvsPage(),
                settings: settings,
              );
            case FilmDetailPage.routeName:
              final args = settings.arguments as FilmDetailArgs;
              return MaterialPageRoute(
                builder: (_) => FilmDetailPage(args: args),
                settings: settings,
              );
            case SearchPage.routeName:
              final args = settings.arguments as bool;
              return CupertinoPageRoute(
                builder: (_) => SearchPage(isMovie: args),
                settings: settings,
              );
            case WatchlistMoviesPage.routeName:
              return MaterialPageRoute(
                builder: (_) => const WatchlistMoviesPage(),
                settings: settings,
              );
            case AboutPage.routeName:
              return MaterialPageRoute(
                builder: (_) => const AboutPage(),
                settings: settings,
              );
            default:
              return MaterialPageRoute(
                builder: (_) {
                  return const Scaffold(
                    body: Center(
                      child: Text('Page not found :('),
                    ),
                  );
                },
                settings: settings,
              );
          }
        },
      ),
    );
  }
}
