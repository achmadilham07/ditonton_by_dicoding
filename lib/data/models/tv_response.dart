// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:ditonton/data/models/tv_model.dart';
import 'package:equatable/equatable.dart';

class TvResponse extends Equatable {
  TvResponse({
    this.page,
    required this.results,
    this.totalPages,
    this.totalResults,
  });

  int? page;
  List<TvModel> results;
  int? totalPages;
  int? totalResults;

  factory TvResponse.fromJson(String str) =>
      TvResponse.fromMap(json.decode(str));

  factory TvResponse.fromMap(Map<String, dynamic> json) => TvResponse(
        page: json["page"],
        results:
            List<TvModel>.from(json["results"].map((x) => TvModel.fromMap(x))),
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
      );

  Map<String, dynamic> toMap() => {
        "page": page,
        "results": List<dynamic>.from(results.map((x) => x.toMap())),
        "total_pages": totalPages,
        "total_results": totalResults,
      };

  @override
  List<Object?> get props => [
        page,
        results,
        totalPages,
        totalResults,
      ];
}
