import 'dart:convert';

import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/datasources/film_remote_data_source.dart';
import 'package:ditonton/data/models/episode_response.dart';
import 'package:ditonton/data/models/movie_detail_model.dart';
import 'package:ditonton/data/models/movie_response.dart';
import 'package:ditonton/data/models/tv_detail_model.dart';
import 'package:ditonton/data/models/tv_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';
import '../../json_reader.dart';

void main() {
  const apiKey = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
  const baseUrl = 'https://api.themoviedb.org/3';

  late FilmRemoteDataSourceImpl dataSource;
  late MockIOClient mockIOClient;

  setUp(() {
    mockIOClient = MockIOClient();
    dataSource = FilmRemoteDataSourceImpl(client: mockIOClient);
  });

  group("MOVIES", () {
    group('get Now Playing Movies', () {
      final tMovieList = MovieResponse.fromJson(
              json.decode(readJson('dummy_data/movie/now_playing.json')))
          .movieList;

      test('should return list of Movie Model when the response code is 200',
          () async {
        // arrange
        when(mockIOClient.get(Uri.parse('$baseUrl/movie/now_playing?$apiKey')))
            .thenAnswer((_) async => http.Response(
                readJson('dummy_data/movie/now_playing.json'), 200));
        // act
        final result = await dataSource.getNowPlayingMovies();
        // assert
        expect(result, equals(tMovieList));
      });

      test(
          'should throw a ServerException when the response code is 404 or other',
          () async {
        // arrange
        when(mockIOClient.get(Uri.parse('$baseUrl/movie/now_playing?$apiKey')))
            .thenAnswer((_) async => http.Response('Not Found', 404));
        // act
        final call = dataSource.getNowPlayingMovies();
        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      });
    });

    group('get Popular Movies', () {
      final tMovieList = MovieResponse.fromJson(
              json.decode(readJson('dummy_data/movie/popular.json')))
          .movieList;

      test('should return list of movies when response is success (200)',
          () async {
        // arrange
        when(mockIOClient.get(Uri.parse('$baseUrl/movie/popular?$apiKey')))
            .thenAnswer((_) async =>
                http.Response(readJson('dummy_data/movie/popular.json'), 200));
        // act
        final result = await dataSource.getPopularMovies();
        // assert
        expect(result, tMovieList);
      });

      test(
          'should throw a ServerException when the response code is 404 or other',
          () async {
        // arrange
        when(mockIOClient.get(Uri.parse('$baseUrl/movie/popular?$apiKey')))
            .thenAnswer((_) async => http.Response('Not Found', 404));
        // act
        final call = dataSource.getPopularMovies();
        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      });
    });

    group('get Top Rated Movies', () {
      final tMovieList = MovieResponse.fromJson(
              json.decode(readJson('dummy_data/movie/top_rated.json')))
          .movieList;

      test('should return list of movies when response code is 200 ', () async {
        // arrange
        when(mockIOClient.get(Uri.parse('$baseUrl/movie/top_rated?$apiKey')))
            .thenAnswer((_) async => http.Response(
                readJson('dummy_data/movie/top_rated.json'), 200));
        // act
        final result = await dataSource.getTopRatedMovies();
        // assert
        expect(result, tMovieList);
      });

      test('should throw ServerException when response code is other than 200',
          () async {
        // arrange
        when(mockIOClient.get(Uri.parse('$baseUrl/movie/top_rated?$apiKey')))
            .thenAnswer((_) async => http.Response('Not Found', 404));
        // act
        final call = dataSource.getTopRatedMovies();
        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      });
    });

    group('get movie detail', () {
      const tId = 1;
      final tMovieDetail = MovieDetailResponse.fromJson(
          json.decode(readJson('dummy_data/movie/movie_detail.json')));

      test('should return movie detail when the response code is 200',
          () async {
        // arrange
        when(mockIOClient.get(Uri.parse('$baseUrl/movie/$tId?$apiKey')))
            .thenAnswer((_) async => http.Response(
                readJson('dummy_data/movie/movie_detail.json'), 200));
        // act
        final result = await dataSource.getMovieDetail(tId);
        // assert
        expect(result, equals(tMovieDetail));
      });

      test(
          'should throw Server Exception when the response code is 404 or other',
          () async {
        // arrange
        when(mockIOClient.get(Uri.parse('$baseUrl/movie/$tId?$apiKey')))
            .thenAnswer((_) async => http.Response('Not Found', 404));
        // act
        final call = dataSource.getMovieDetail(tId);
        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      });
    });

    group('get movie recommendations', () {
      final tMovieList = MovieResponse.fromJson(json
              .decode(readJson('dummy_data/movie/movie_recommendations.json')))
          .movieList;
      const tId = 1;

      test('should return list of Movie Model when the response code is 200',
          () async {
        // arrange
        when(mockIOClient
                .get(Uri.parse('$baseUrl/movie/$tId/recommendations?$apiKey')))
            .thenAnswer((_) async => http.Response(
                readJson('dummy_data/movie/movie_recommendations.json'), 200));
        // act
        final result = await dataSource.getMovieRecommendations(tId);
        // assert
        expect(result, equals(tMovieList));
      });

      test(
          'should throw Server Exception when the response code is 404 or other',
          () async {
        // arrange
        when(mockIOClient
                .get(Uri.parse('$baseUrl/movie/$tId/recommendations?$apiKey')))
            .thenAnswer((_) async => http.Response('Not Found', 404));
        // act
        final call = dataSource.getMovieRecommendations(tId);
        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      });
    });

    group('search movies', () {
      final tSearchResult = MovieResponse.fromJson(json
              .decode(readJson('dummy_data/movie/search_spiderman_movie.json')))
          .movieList;
      const tQuery = 'Spiderman';

      test('should return list of movies when response code is 200', () async {
        // arrange
        when(mockIOClient
                .get(Uri.parse('$baseUrl/search/movie?$apiKey&query=$tQuery')))
            .thenAnswer((_) async => http.Response(
                readJson('dummy_data/movie/search_spiderman_movie.json'), 200));
        // act
        final result = await dataSource.searchMovies(tQuery);
        // assert
        expect(result, tSearchResult);
      });

      test('should throw ServerException when response code is other than 200',
          () async {
        // arrange
        when(mockIOClient
                .get(Uri.parse('$baseUrl/search/movie?$apiKey&query=$tQuery')))
            .thenAnswer((_) async => http.Response('Not Found', 404));
        // act
        final call = dataSource.searchMovies(tQuery);
        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      });
    });
  });

  ///
  ///
  /// TV SERIES
  ///
  ///
  group('TV SERIES', () {
    group('get Now Playing Tvs', () {
      final stringJson = readJson('dummy_data/tv/on_the_air.json');
      final tTvList = TvResponse.fromJson(stringJson).results;

      test('should return list of Tv Model when the response code is 200',
          () async {
        // arrange
        when(mockIOClient.get(Uri.parse('$baseUrl/tv/on_the_air?$apiKey')))
            .thenAnswer((_) async => http.Response(stringJson, 200));
        // act
        final result = await dataSource.getNowPlayingTv();
        // assert
        expect(result, equals(tTvList));
      });

      test(
          'should throw a ServerException when the response code is 404 or other',
          () async {
        // arrange
        when(mockIOClient.get(Uri.parse('$baseUrl/tv/on_the_air?$apiKey')))
            .thenAnswer((_) async => http.Response('Not Found', 404));
        // act
        final call = dataSource.getNowPlayingTv();
        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      });
    });

    group('get Popular Tvs', () {
      final tTvList =
          TvResponse.fromJson(readJson('dummy_data/tv/popular.json')).results;

      test('should return list of tvs when response is success (200)',
          () async {
        // arrange
        when(mockIOClient.get(Uri.parse('$baseUrl/tv/popular?$apiKey')))
            .thenAnswer((_) async =>
                http.Response(readJson('dummy_data/tv/popular.json'), 200));
        // act
        final result = await dataSource.getPopularTv();
        // assert
        expect(result, tTvList);
      });

      test(
          'should throw a ServerException when the response code is 404 or other',
          () async {
        // arrange
        when(mockIOClient.get(Uri.parse('$baseUrl/tv/popular?$apiKey')))
            .thenAnswer((_) async => http.Response('Not Found', 404));
        // act
        final call = dataSource.getPopularTv();
        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      });
    });

    group('get Top Rated Tvs', () {
      final tTvList =
          TvResponse.fromJson(readJson('dummy_data/tv/top_rated.json')).results;

      test('should return list of tvs when response code is 200 ', () async {
        // arrange
        when(mockIOClient.get(Uri.parse('$baseUrl/tv/top_rated?$apiKey')))
            .thenAnswer((_) async =>
                http.Response(readJson('dummy_data/tv/top_rated.json'), 200));
        // act
        final result = await dataSource.getTopRatedTv();
        // assert
        expect(result, tTvList);
      });

      test('should throw ServerException when response code is other than 200',
          () async {
        // arrange
        when(mockIOClient.get(Uri.parse('$baseUrl/tv/top_rated?$apiKey')))
            .thenAnswer((_) async => http.Response('Not Found', 404));
        // act
        final call = dataSource.getTopRatedTv();
        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      });
    });

    group('get tv detail', () {
      const tId = 500;
      final tTvDetail =
          TvDetailResponse.fromJson(readJson('dummy_data/tv/tv_detail.json'));

      test('should return tv detail when the response code is 200', () async {
        // arrange
        when(mockIOClient.get(Uri.parse('$baseUrl/tv/$tId?$apiKey')))
            .thenAnswer((_) async =>
                http.Response(readJson('dummy_data/tv/tv_detail.json'), 200));
        // act
        final result = await dataSource.getTvDetail(tId);
        // assert
        expect(result, equals(tTvDetail));
      });

      test(
          'should throw Server Exception when the response code is 404 or other',
          () async {
        // arrange
        when(mockIOClient.get(Uri.parse('$baseUrl/tv/$tId?$apiKey')))
            .thenAnswer((_) async => http.Response('Not Found', 404));
        // act
        final call = dataSource.getTvDetail(tId);
        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      });
    });

    group('get tv recommendations', () {
      final tTvList =
          TvResponse.fromJson(readJson('dummy_data/tv/tv_recommendation.json'))
              .results;
      const tId = 500;

      test('should return list of Tv Model when the response code is 200',
          () async {
        // arrange
        when(mockIOClient
                .get(Uri.parse('$baseUrl/tv/$tId/recommendations?$apiKey')))
            .thenAnswer((_) async => http.Response(
                readJson('dummy_data/tv/tv_recommendation.json'), 200));
        // act
        final result = await dataSource.getTvRecommendations(tId);
        // assert
        expect(result, equals(tTvList));
      });

      test(
          'should throw Server Exception when the response code is 404 or other',
          () async {
        // arrange
        when(mockIOClient
                .get(Uri.parse('$baseUrl/tv/$tId/recommendations?$apiKey')))
            .thenAnswer((_) async => http.Response('Not Found', 404));
        // act
        final call = dataSource.getTvRecommendations(tId);
        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      });
    });

    group('search tvs', () {
      final tSearchResult = TvResponse.fromJson(
              readJson('dummy_data/tv/search_spiderman_tv.json'))
          .results;
      const tQuery = 'spiderman';

      test('should return list of tvs when response code is 200', () async {
        // arrange
        when(mockIOClient
                .get(Uri.parse('$baseUrl/search/tv?$apiKey&query=$tQuery')))
            .thenAnswer((_) async => http.Response(
                readJson('dummy_data/tv/search_spiderman_tv.json'), 200));
        // act
        final result = await dataSource.searchTv(tQuery);
        // assert
        expect(result, tSearchResult);
      });

      test('should throw ServerException when response code is other than 200',
          () async {
        // arrange
        when(mockIOClient
                .get(Uri.parse('$baseUrl/search/tv?$apiKey&query=$tQuery')))
            .thenAnswer((_) async => http.Response('Not Found', 404));
        // act
        final call = dataSource.searchTv(tQuery);
        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      });
    });

    group('episode tvs', () {
      final tEpisodeResult = EpisodeResponse.fromJson(
          readJson('dummy_data/tv/tv_detail_episode.json'));
      const idTv = 1991;
      const season = 1;

      test('should return list of episode tvs when response code is 200',
          () async {
        // arrange
        when(mockIOClient
                .get(Uri.parse('$baseUrl/tv/$idTv/season/$season?$apiKey')))
            .thenAnswer((_) async => http.Response(
                readJson('dummy_data/tv/tv_detail_episode.json'), 200));
        // act
        final result = await dataSource.getTvEpisode(idTv, season);
        // assert
        expect(result, tEpisodeResult);
      });

      test('should throw ServerException when response code is other than 200',
          () async {
        // arrange
        when(mockIOClient
                .get(Uri.parse('$baseUrl/tv/$idTv/season/$season?$apiKey')))
            .thenAnswer((_) async => http.Response('Not Found', 404));
        // act
        final call = dataSource.getTvEpisode(idTv, season);
        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      });
    });
  });
}
