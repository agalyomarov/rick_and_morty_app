import 'package:rick_and_morty_app/models/character.dart';

abstract class SearchState {}

final class SearchEmptyState extends SearchState {}

final class SearchLoadingState extends SearchState {}

final class SearchLoadedState extends SearchState {
  final List<Character> characters;
  final String name;
  SearchLoadedState({required this.characters, required this.name});
}

final class SearchErrorState extends SearchState {
  final String message;
  SearchErrorState({required this.message});
}
