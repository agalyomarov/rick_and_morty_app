import 'package:rick_and_morty_app/models/character.dart';

abstract class CharacterState {}

final class CharacterEmptyState extends CharacterState {}

final class CharacterDataState extends CharacterState {
  final List<Character> characters;
  final bool isLoading;
  final int page;
  final int limit;
  CharacterDataState({required this.characters, required this.isLoading, required this.page, this.limit = 10});

  CharacterDataState copyWith({List<Character>? characters, bool? isLoading, int? page}) {
    return CharacterDataState(
      characters: characters ?? this.characters,
      isLoading: isLoading ?? this.isLoading,
      page: page ?? this.page,
    );
  }
}

final class CharacterErrorState extends CharacterState {
  final String message;
  CharacterErrorState({required this.message});
}
