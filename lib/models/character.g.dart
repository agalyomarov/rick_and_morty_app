// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Character _$CharacterFromJson(Map<String, dynamic> json) => Character(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  status: json['status'] as String,
  species: json['species'] as String,
  image: json['image'] as String,
  origin: Location.fromJson(json['origin'] as Map<String, dynamic>),
  location: Location.fromJson(json['location'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CharacterToJson(Character instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'status': instance.status,
  'species': instance.species,
  'image': instance.image,
  'origin': instance.origin,
  'location': instance.location,
};
