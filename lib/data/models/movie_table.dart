// ignore_for_file: must_be_immutable

import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:ditonton/domain/entities/watchlist.dart';
import 'package:equatable/equatable.dart';

class MovieTable extends Equatable {
  int? id;
  String? title;
  String? posterPath;
  String? overview;
  num? isMovie;

  MovieTable({
    this.id,
    this.title,
    this.posterPath,
    this.overview,
    this.isMovie,
  });

  factory MovieTable.fromMovieEntity(MovieDetail movie) => MovieTable(
        id: movie.id,
        title: movie.title,
        posterPath: movie.posterPath,
        overview: movie.overview,
        isMovie: 0,
      );

  factory MovieTable.fromTvEntity(TvDetail tv) => MovieTable(
        id: tv.id ?? 0,
        title: tv.name,
        posterPath: tv.posterPath,
        overview: tv.overview,
        isMovie: 1,
      );

  factory MovieTable.fromMap(Map<String, dynamic> map) => MovieTable(
        id: map['id'],
        title: map['title'],
        posterPath: map['posterPath'],
        overview: map['overview'],
        isMovie: map['isMovie'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'posterPath': posterPath,
        'overview': overview,
        'isMovie': isMovie,
      };

  Watchlist toEntity() => Watchlist(
        id: id ?? 0,
        overview: overview,
        posterPath: posterPath,
        title: title,
        isMovie: isMovie == 0,
      );

  @override
  List<Object?> get props => [
        id,
        title,
        posterPath,
        overview,
        isMovie,
      ];
}
