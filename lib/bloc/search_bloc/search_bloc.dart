import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty_app/bloc/search_bloc/search_event.dart';
import 'package:rick_and_morty_app/bloc/search_bloc/search_state.dart';
import 'package:rick_and_morty_app/core/services/locator_service.dart';
import 'package:rick_and_morty_app/services/characters_service.dart';

final class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(SearchEmptyState()) {
    on<SearchEventInputEvent>(_onInput);
  }

  Future<void> _onInput(SearchEventInputEvent event, Emitter<SearchState> emit) async {
    if (state is SearchLoadingState) {
      return;
    }

    emit(SearchLoadingState());
    try {
      final charactersService = sl<CharactersService>();
      final characters = await charactersService.getCharacters(page: 1, name: event.name);
      emit(SearchLoadedState(characters: characters, name: event.name));
    } catch (e) {
      emit(SearchErrorState(message: e.toString()));
    }
  }
}
