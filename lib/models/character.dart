import 'package:json_annotation/json_annotation.dart';
import 'package:rick_and_morty_app/core/type_def/type_def.dart';
import 'package:rick_and_morty_app/models/location.dart';

part 'character.g.dart';

@JsonSerializable()
class Character {
  final int id;
  final String name;
  final String status;
  final String species;
  final String image;
  final Location origin;
  final Location location;

  Character({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.image,
    required this.origin,
    required this.location,
  });

  factory Character.fromJson(Json json) => _$CharacterFromJson(json);

  Json toJson() => _$CharacterToJson(this);
}
