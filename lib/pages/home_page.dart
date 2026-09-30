import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rick_and_morty_app/bloc/character_bloc/character_bloc.dart';
import 'package:rick_and_morty_app/bloc/character_bloc/character_event.dart';
import 'package:rick_and_morty_app/bloc/character_bloc/character_state.dart';
import 'package:rick_and_morty_app/core/constants/app_colors.dart';
import 'package:rick_and_morty_app/core/constants/app_routes.dart';
import 'package:rick_and_morty_app/models/character.dart';
import 'package:rick_and_morty_app/widgets/character_card.dart';
import 'package:rick_and_morty_app/widgets/error_message.dart';

class HomePage extends StatefulWidget {
  const new({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final remainingScrollHeight = _scrollController.position.maxScrollExtent - _scrollController.position.pixels;
    if (remainingScrollHeight <= 0) {
      context.read<CharacterBloc>().add(CharacterLoadEvent());
    }
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Characters", style: TextStyle(color: AppColors.bodyText)),
        actions: [
          IconButton(
            onPressed: () {
              context.go(AppRoutes.search());
            },
            icon: Icon(Icons.search, color: AppColors.bodyText),
          ),
          SizedBox(width: 10),
        ],
        centerTitle: true,
        backgroundColor: AppColors.mainBg,
      ),
      backgroundColor: AppColors.mainBg,
      body: BlocBuilder<CharacterBloc, CharacterState>(
        builder: (context, state) {
          if (state is CharacterEmptyState) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 20,
                children: [
                  Text(
                    "Персонажы еще не закружены",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context.read<CharacterBloc>().add(CharacterLoadEvent());
                    },
                    child: Text("Загрузить"),
                  ),
                ],
              ),
            );
          }

          if (state is CharacterErrorState) {
            return ErrorMessage(
              message: state.message,
              onPressed: () {
                context.read<CharacterBloc>().add(CharacterLoadEvent());
              },
            );
          }

          if (state is CharacterDataState && state.characters.isEmpty && state.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (state is CharacterDataState && state.characters.isNotEmpty) {
            return ListView.separated(
              controller: _scrollController,
              itemBuilder: (context, index) {
                if (state.isLoading && index == state.characters.length - 1) {
                  return Column(
                    children: [
                      characterCard(state.characters[index], index),
                      Padding(padding: const EdgeInsets.all(8.0), child: CircularProgressIndicator()),
                    ],
                  );
                }
                return characterCard(state.characters[index], index);
              },
              separatorBuilder: (context, index) {
                return Divider(color: Colors.grey[700], height: 12);
              },
              itemCount: state.characters.length,
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  GestureDetector characterCard(Character character, int index) {
    return GestureDetector(
      onTap: () {
        context.go(AppRoutes.character(character.id.toString()));
      },
      child: CharacterCard(character: character),
    );
  }
}
