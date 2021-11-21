import 'package:ditonton/data/datasources/db/database_helper.dart';
import 'package:ditonton/data/datasources/film_local_data_source.dart';
import 'package:ditonton/data/datasources/film_remote_data_source.dart';
import 'package:ditonton/domain/repositories/movie_repository.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';

@GenerateMocks([
  MovieRepository,
  FilmRemoteDataSource,
  MovieLocalDataSource,
  DatabaseHelper,
], customMocks: [
  MockSpec<http.Client>(as: #MockHttpClient)
])
void main() {}
