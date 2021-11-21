// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';

class Watchlist extends Equatable {
  int id;
  String? overview;
  String? posterPath;
  String? title;
  bool? isMovie;

  Watchlist({
    required this.id,
    required this.overview,
    required this.posterPath,
    required this.title,
    required this.isMovie,
  });

  @override
  List<Object?> get props => [
        id,
        overview,
        posterPath,
        title,
        isMovie,
      ];
}
