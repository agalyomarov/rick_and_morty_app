abstract class SearchEvent {}

final class SearchEventInputEvent extends SearchEvent {
  final String name;
  SearchEventInputEvent({required this.name});
}
