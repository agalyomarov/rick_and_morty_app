import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rick_and_morty_app/bloc/character_detail_bloc/character_detail_bloc.dart';
import 'package:rick_and_morty_app/bloc/character_detail_bloc/character_detail_event.dart';
import 'package:rick_and_morty_app/bloc/character_detail_bloc/character_detail_state.dart';
import 'package:rick_and_morty_app/core/constants/app_colors.dart';

class CharacterPage extends StatelessWidget {
  final String id;
  const new({required this.id, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.pop(true);
          },
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
        ),
        title: Text("Characters with ID: $id", style: TextStyle(color: AppColors.bodyText)),
        centerTitle: true,
        backgroundColor: AppColors.mainBg,
      ),
      backgroundColor: AppColors.mainBg,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<CharacterDetailBloc, CharacterDetailState>(
          builder: (context, state) {
            if (state is CharacterDetailEmptyState) {
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
                        context.read<CharacterDetailBloc>().add(CharacterDetailLoadEvent(id: id));
                      },
                      child: Text("Загрузить"),
                    ),
                  ],
                ),
              );
            }

            if (state is CharacterDetailErrorState) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 10,
                  children: [
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.red.shade600),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        context.read<CharacterDetailBloc>().add(CharacterDetailLoadEvent(id: id));
                      },
                      child: Text("Обновить"),
                    ),
                  ],
                ),
              );
            }

            if (state is CharacterDetailLoadingState) {
              return Center(child: CircularProgressIndicator());
            }

            if (state is CharacterDetailLoadedState) {
              final character = state.character;
              return Container(
                height: 150,
                decoration: BoxDecoration(color: AppColors.cellBg, borderRadius: BorderRadius.circular(12)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      flex: 2,
                      child: CachedNetworkImage(
                        imageUrl: character.image,
                        placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        fit: BoxFit.cover,
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  character.name,
                                  style: TextStyle(
                                    color: AppColors.bodyText,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  spacing: 4,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: character.status == "Alive" ? Colors.green : Colors.red,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      width: 6,
                                      height: 6,
                                    ),
                                    Text(character.status, style: TextStyle(fontSize: 10, color: Colors.white)),
                                    Text("-", style: TextStyle(fontSize: 10, color: Colors.white)),
                                    Text(character.species, style: TextStyle(fontSize: 10, color: Colors.white)),
                                  ],
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Last known location:",
                                  style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500, fontSize: 9),
                                ),
                                Text(
                                  character.location.name,
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 11),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Origin:",
                                  style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500, fontSize: 9),
                                ),
                                Text(
                                  character.origin.name,
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 11),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            return SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
