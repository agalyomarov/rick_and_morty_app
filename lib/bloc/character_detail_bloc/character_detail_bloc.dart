import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty_app/bloc/character_detail_bloc/character_detail_event.dart';
import 'package:rick_and_morty_app/bloc/character_detail_bloc/character_detail_state.dart';
import 'package:rick_and_morty_app/core/services/locator_service.dart';
import 'package:rick_and_morty_app/services/characters_service.dart';

final class CharacterDetailBloc extends Bloc<CharacterDetailEvent, CharacterDetailState> {
  CharacterDetailBloc() : super(CharacterDetailEmptyState()) {
    on<CharacterDetailLoadEvent>(_onCharacterDetailLoad);
  }

  Future<void> _onCharacterDetailLoad(CharacterDetailLoadEvent event, Emitter<CharacterDetailState> emit) async {
    if (state is CharacterDetailLoadingState) {
      return;
    }

    try {
      final charactersService = sl<CharactersService>();

      emit(CharacterDetailLoadingState());
      final character = await charactersService.getCharacter(id: event.id);
      emit(CharacterDetailLoadedState(character: character));
    } catch (e) {
      emit(CharacterDetailErrorState(message: e.toString()));
    }
  }
}
