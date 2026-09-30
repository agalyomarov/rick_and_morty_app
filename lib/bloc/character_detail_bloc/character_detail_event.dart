abstract class CharacterDetailEvent {}

final class CharacterDetailLoadEvent extends CharacterDetailEvent {
  final String id;
  CharacterDetailLoadEvent({required this.id});
}
