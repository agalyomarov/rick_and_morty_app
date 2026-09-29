import 'package:json_annotation/json_annotation.dart';
import 'package:rick_and_morty_app/core/type_def/type_def.dart';

part 'location.g.dart';

@JsonSerializable()
class Location {
  final String name;
  final String url;

  Location({required this.name, required this.url});

  factory Location.fromJson(Json json) => _$LocationFromJson(json);

  Json toJson() => _$LocationToJson(this);
}
