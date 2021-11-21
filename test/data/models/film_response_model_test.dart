import 'dart:convert';

import 'package:ditonton/data/models/movie_model.dart';
import 'package:ditonton/data/models/movie_response.dart';
import 'package:ditonton/data/models/tv_model.dart';
import 'package:ditonton/data/models/tv_response.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../json_reader.dart';

void main() {
  group('MOVIES', () {
    const tMovieModel = MovieModel(
      adult: false,
      backdropPath: "/path.jpg",
      genreIds: [1, 2, 3, 4],
      id: 1,
      originalTitle: "Original Title",
      overview: "Overview",
      popularity: 1.0,
      posterPath: "/path.jpg",
      releaseDate: "2020-05-05",
      title: "Title",
      video: false,
      voteAverage: 1.0,
      voteCount: 1,
    );
    const tMovieResponseModel =
        MovieResponse(movieList: <MovieModel>[tMovieModel]);
    group('fromJson', () {
      test('should return a valid model from JSON', () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(readJson('dummy_data/movie/now_playing.json'));
        // act
        final result = MovieResponse.fromJson(jsonMap);
        // assert
        expect(result, tMovieResponseModel);
      });
    });

    group('toJson', () {
      test('should return a JSON map containing proper data', () async {
        // arrange

        // act
        final result = tMovieResponseModel.toJson();
        // assert
        final expectedJsonMap = {
          "results": [
            {
              "adult": false,
              "backdrop_path": "/path.jpg",
              "genre_ids": [1, 2, 3, 4],
              "id": 1,
              "original_title": "Original Title",
              "overview": "Overview",
              "popularity": 1.0,
              "poster_path": "/path.jpg",
              "release_date": "2020-05-05",
              "title": "Title",
              "video": false,
              "vote_average": 1.0,
              "vote_count": 1
            }
          ],
        };
        expect(result, expectedJsonMap);
      });
    });
  });

  group('TV SERIES', () {
    final tMovieModel = TvModel(
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
    final tMovieResponseModel = TvResponse(
      page: 1,
      totalPages: 60,
      totalResults: 1190,
      results: <TvModel>[tMovieModel],
    );
    group('fromJson', () {
      test('should return a valid model from JSON', () async {
        // arrange
        final jsonMap = (readJson('dummy_data/tv/on_the_air.json'));
        // act
        final result = TvResponse.fromJson(jsonMap);
        // assert
        expect(result, tMovieResponseModel);
      });
    });

    group('toJson', () {
      test('should return a JSON map containing proper data', () async {
        // arrange

        // act
        final result = tMovieResponseModel.toMap();
        // assert
        final expectedJsonMap = {
          "page": 1,
          "results": [
            {
              "backdrop_path": "/oC9SgtJTDCEpWnTBtVGoAvjl5hb.jpg",
              "first_air_date": "2006-09-18",
              "genre_ids": [10767],
              "id": 1991,
              "name": "Rachael Ray",
              "origin_country": ["US"],
              "original_language": "en",
              "original_name": "Rachael Ray",
              "overview":
                  "Rachael Ray, also known as The Rachael Ray Show, is an American talk show starring Rachael Ray that debuted in syndication in the United States and Canada on September 18, 2006. It is filmed at Chelsea Television Studios in New York City. The show's 8th season premiered on September 9, 2013, and became the last Harpo show in syndication to switch to HD with a revamped studio.",
              "popularity": 2907.317,
              "poster_path": "/dsAJhCLYX1fiNRoiiJqR6Up4aJ.jpg",
              "vote_average": 5.8,
              "vote_count": 29
            }
          ],
          "total_pages": 60,
          "total_results": 1190,
        };
        expect(result, expectedJsonMap);
      });
    });
  });
}
