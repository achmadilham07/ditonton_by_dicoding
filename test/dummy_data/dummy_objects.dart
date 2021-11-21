import 'package:ditonton/data/models/episode_response.dart';
import 'package:ditonton/data/models/movie_table.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:ditonton/domain/entities/watchlist.dart';

final testMovie = Movie(
  adult: false,
  backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
  genreIds: const [14, 28],
  id: 557,
  originalTitle: 'Spider-Man',
  overview:
      'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
  popularity: 60.441,
  posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
  releaseDate: '2002-05-01',
  title: 'Spider-Man',
  video: false,
  voteAverage: 7.2,
  voteCount: 13507,
);

final testMovieList = [testMovie];

const testMovieDetail = MovieDetail(
  adult: false,
  backdropPath: 'backdropPath',
  genres: [Genre(id: 1, name: 'Action')],
  id: 1,
  originalTitle: 'originalTitle',
  overview: 'overview',
  posterPath: 'posterPath',
  releaseDate: 'releaseDate',
  runtime: 120,
  title: 'title',
  voteAverage: 1,
  voteCount: 1,
);

final testWatchlistMovie = Watchlist(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
  isMovie: true,
);

final testWatchlistMovieList = [testWatchlistMovie];

final testMovieTable = MovieTable(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
  isMovie: 0,
);

final testMovieMap = {
  'id': 1,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'title': 'title',
  'isMovie': 0,
};

///
///
/// TV SERIES
///
///

final testTv = Tv(
  voteCount: 29,
  voteAverage: 5.8,
  backdropPath: '/oC9SgtJTDCEpWnTBtVGoAvjl5hb.jpg',
  posterPath: '/dsAJhCLYX1fiNRoiiJqR6Up4aJ.jpg',
  popularity: 2907.317,
  overview:
      "Rachael Ray, also known as The Rachael Ray Show, is an American talk show starring Rachael Ray that debuted in syndication in the United States and Canada on September 18, 2006. It is filmed at Chelsea Television Studios in New York City. The show's 8th season premiered on September 9, 2013, and became the last Harpo show in syndication to switch to HD with a revamped studio.",
  originalName: 'Rachael Ray',
  originalLanguage: 'en',
  originCountry: const ['US'],
  name: 'Rachael Ray',
  id: 1991,
  genreIds: const [10767],
  firstAirDate: '2006-09-18',
);

final testTvList = [testTv];

final testTvDetail = TvDetail(
  voteCount: 29,
  voteAverage: 5.8,
  backdropPath: '/oC9SgtJTDCEpWnTBtVGoAvjl5hb.jpg',
  posterPath: '/dsAJhCLYX1fiNRoiiJqR6Up4aJ.jpg',
  popularity: 2907.317,
  overview:
      "Rachael Ray, also known as The Rachael Ray Show, is an American talk show starring Rachael Ray that debuted in syndication in the United States and Canada on September 18, 2006. It is filmed at Chelsea Television Studios in New York City. The show's 8th season premiered on September 9, 2013, and became the last Harpo show in syndication to switch to HD with a revamped studio.",
  originalName: 'Rachael Ray',
  originalLanguage: 'en',
  originCountry: const ['US'],
  name: 'Rachael Ray',
  id: 1991,
  genres: const [Genre(id: 10767, name: "Talk")],
  firstAirDate: DateTime(2006, 09, 18),
  episodeRunTime: const [60, 42],
  homepage: "http://www.rachaelrayshow.com/",
  type: "Talk Show",
  tagline: "",
  status: "Returning Series",
  inProduction: true,
  numberOfSeasons: 13,
  numberOfEpisodes: 1051,
  languages: const ["en"],
  nextEpisodeToAir: const {
    "air_date": "2021-10-20",
    "episode_number": 28,
    "id": 3286382,
    "name":
        "Jeremy Sisto Dishes on \"Law & Order\" Revival + Rach's Greek-Style Burger Patties",
    "overview":
        "\"FBI's\" Jeremy Sisto is talking about the newest season of the hit show and dishing on the \"Law & Order\" revival. Plus, makeovers are BACK! Clinton Kelly is hooking up an inspiring Philadelphia police officer with our first makeover back in the studio. Later, a real-life spy shares safety tips. For dinner, Rachael's making delish Greek-style burger patties.",
    "production_code": "",
    "season_number": 16,
    "still_path": null,
    "vote_average": 0.0,
    "vote_count": 0
  },
  lastAirDate: DateTime(2021, 10, 19),
);

final testWatchlistTv = Watchlist(
  id: 1991,
  title: 'Rachael Ray',
  posterPath: '/dsAJhCLYX1fiNRoiiJqR6Up4aJ.jpg',
  overview:
      "Rachael Ray, also known as The Rachael Ray Show, is an American talk show starring Rachael Ray that debuted in syndication in the United States and Canada on September 18, 2006. It is filmed at Chelsea Television Studios in New York City. The show's 8th season premiered on September 9, 2013, and became the last Harpo show in syndication to switch to HD with a revamped studio.",
  isMovie: false,
);

final testWatchlistTvList = [testWatchlistTv];

final testTvTable = MovieTable(
  id: 1991,
  title: 'Rachael Ray',
  posterPath: '/dsAJhCLYX1fiNRoiiJqR6Up4aJ.jpg',
  overview:
      "Rachael Ray, also known as The Rachael Ray Show, is an American talk show starring Rachael Ray that debuted in syndication in the United States and Canada on September 18, 2006. It is filmed at Chelsea Television Studios in New York City. The show's 8th season premiered on September 9, 2013, and became the last Harpo show in syndication to switch to HD with a revamped studio.",
  isMovie: 1,
);

final testTvMap = {
  'id': 1991,
  'overview':
      "Rachael Ray, also known as The Rachael Ray Show, is an American talk show starring Rachael Ray that debuted in syndication in the United States and Canada on September 18, 2006. It is filmed at Chelsea Television Studios in New York City. The show's 8th season premiered on September 9, 2013, and became the last Harpo show in syndication to switch to HD with a revamped studio.",
  'posterPath': '/dsAJhCLYX1fiNRoiiJqR6Up4aJ.jpg',
  'title': 'Rachael Ray',
  'isMovie': 1,
};

///
/// EPISODE
///
final testTvEpisode = Episode(
  airDate: "2006-09-18",
  episodeNumber: 1,
  id: 24809,
  name: "Rachael's Premiere",
  overview: "",
  productionCode: "",
  seasonNumber: 1,
  stillPath: null,
  voteAverage: 0.0,
  voteCount: 0.0,
);
final testTvEpisodeList = <Episode>[testTvEpisode];
final testTvEpisodeResponse = EpisodeResponse(
  id: "52571e1819c2957114101a1a",
  airDate: DateTime(2006, 09, 18),
  episodes: testTvEpisodeList,
  name: "Season 1",
  overview: "",
  episodeResponseId: 1438,
  posterPath: null,
  seasonNumber: 1,
);
