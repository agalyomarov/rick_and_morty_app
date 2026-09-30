import 'package:rick_and_morty_app/models/character.dart';

abstract class CharacterDetailState {}

final class CharacterDetailEmptyState extends CharacterDetailState {}

final class CharacterDetailLoadingState extends CharacterDetailState {}

final class CharacterDetailLoadedState extends CharacterDetailState {
  final Character character;
  CharacterDetailLoadedState({required this.character});
}

final class CharacterDetailErrorState extends CharacterDetailState {
  final String message;
  CharacterDetailErrorState({required this.message});
}
