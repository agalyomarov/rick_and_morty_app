import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty_app/bloc/character_bloc/character_event.dart';
import 'package:rick_and_morty_app/bloc/character_bloc/character_state.dart';
import 'package:rick_and_morty_app/core/services/locator_service.dart';
import 'package:rick_and_morty_app/services/characters_service.dart';

final class CharacterBloc extends Bloc<CharacterEvent, CharacterState> {
  CharacterBloc() : super(CharacterEmptyState()) {
    on<CharacterLoadEvent>(_onCharacterLoad);
  }

  Future<void> _onCharacterLoad(CharacterLoadEvent event, Emitter<CharacterState> emit) async {
    final currentState = state;

    // Если уже идёт загрузка — ничего не делаем
    if (currentState is CharacterDataState && currentState.isLoading) {
      return;
    }

    try {
      final charactersService = sl<CharactersService>();

      // Первая загрузка
      if (currentState is CharacterEmptyState || currentState is CharacterErrorState) {
        emit(CharacterDataState(characters: [], isLoading: true, page: 1));

        final newCharacters = await charactersService.getCharacters(page: 1);

        emit(CharacterDataState(characters: newCharacters, isLoading: false, page: 1));

        return;
      }

      // Подгрузка следующей страницы
      if (currentState is CharacterDataState) {
        emit(currentState.copyWith(isLoading: true));

        final nextPage = currentState.page + 1;

        final newCharacters = await charactersService.getCharacters(page: nextPage);

        emit(
          currentState.copyWith(
            characters: [...currentState.characters, ...newCharacters],
            isLoading: false,
            page: nextPage,
          ),
        );
      }
    } catch (e) {
      emit(CharacterErrorState(message: e.toString()));
    }
  }
}
