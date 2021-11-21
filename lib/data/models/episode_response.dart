// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:equatable/equatable.dart';

class EpisodeResponse extends Equatable {
  EpisodeResponse({
    this.id,
    this.airDate,
    this.episodes,
    this.name,
    this.overview,
    this.episodeResponseId,
    this.posterPath,
    this.seasonNumber,
  });

  String? id;
  DateTime? airDate;
  List<Episode>? episodes;
  String? name;
  String? overview;
  num? episodeResponseId;
  String? posterPath;
  num? seasonNumber;

  EpisodeResponse copyWith({
    String? id,
    DateTime? airDate,
    List<Episode>? episodes,
    String? name,
    String? overview,
    num? episodeResponseId,
    String? posterPath,
    num? seasonNumber,
  }) =>
      EpisodeResponse(
        id: id ?? this.id,
        airDate: airDate ?? this.airDate,
        episodes: episodes ?? this.episodes,
        name: name ?? this.name,
        overview: overview ?? this.overview,
        episodeResponseId: episodeResponseId ?? this.episodeResponseId,
        posterPath: posterPath ?? this.posterPath,
        seasonNumber: seasonNumber ?? this.seasonNumber,
      );

  factory EpisodeResponse.fromJson(String str) =>
      EpisodeResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory EpisodeResponse.fromMap(Map<String, dynamic> json) => EpisodeResponse(
        id: json["_id"],
        airDate: DateTime.tryParse(json["air_date"]),
        episodes:
            List<Episode>.from(json["episodes"].map((x) => Episode.fromMap(x))),
        name: json["name"],
        overview: json["overview"],
        episodeResponseId: json["id"],
        posterPath: json["poster_path"],
        seasonNumber: json["season_number"],
      );

  Map<String, dynamic> toMap() => {
        "_id": id,
        "air_date":
            "${airDate!.year.toString().padLeft(4, '0')}-${airDate!.month.toString().padLeft(2, '0')}-${airDate!.day.toString().padLeft(2, '0')}",
        "episodes": List<dynamic>.from(episodes!.map((x) => x.toMap())),
        "name": name,
        "overview": overview,
        "id": episodeResponseId,
        "poster_path": posterPath,
        "season_number": seasonNumber,
      };

  @override
  List<Object?> get props => [
        id,
        airDate,
        episodes,
        name,
        overview,
        episodeResponseId,
        posterPath,
        seasonNumber,
      ];
}

class Episode extends Equatable {
  Episode({
    this.airDate,
    this.episodeNumber,
    this.id,
    this.name,
    this.overview,
    this.productionCode,
    this.seasonNumber,
    this.stillPath,
    this.voteAverage,
    this.voteCount,
  });

  String? airDate;
  num? episodeNumber;
  num? id;
  String? name;
  String? overview;
  String? productionCode;
  num? seasonNumber;
  String? stillPath;
  num? voteAverage;
  num? voteCount;

  Episode copyWith({
    String? airDate,
    num? episodeNumber,
    num? id,
    String? name,
    String? overview,
    String? productionCode,
    num? seasonNumber,
    String? stillPath,
    num? voteAverage,
    num? voteCount,
  }) =>
      Episode(
        airDate: airDate ?? this.airDate,
        episodeNumber: episodeNumber ?? this.episodeNumber,
        id: id ?? this.id,
        name: name ?? this.name,
        overview: overview ?? this.overview,
        productionCode: productionCode ?? this.productionCode,
        seasonNumber: seasonNumber ?? this.seasonNumber,
        stillPath: stillPath ?? this.stillPath,
        voteAverage: voteAverage ?? this.voteAverage,
        voteCount: voteCount ?? this.voteCount,
      );

  factory Episode.fromJson(String str) => Episode.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Episode.fromMap(Map<String, dynamic> json) => Episode(
        airDate: json["air_date"],
        episodeNumber: json["episode_number"],
        id: json["id"],
        name: json["name"],
        overview: json["overview"],
        productionCode: json["production_code"],
        seasonNumber: json["season_number"],
        stillPath: json["still_path"],
        voteAverage: json["vote_average"],
        voteCount: json["vote_count"],
      );

  Map<String, dynamic> toMap() => {
        "air_date": airDate,
        "episode_number": episodeNumber,
        "id": id,
        "name": name,
        "overview": overview,
        "production_code": productionCode,
        "season_number": seasonNumber,
        "still_path": stillPath,
        "vote_average": voteAverage,
        "vote_count": voteCount,
      };

  @override
  List<Object?> get props => [
        airDate,
        episodeNumber,
        id,
        name,
        overview,
        productionCode,
        seasonNumber,
        stillPath,
        voteAverage,
        voteCount,
      ];
}
