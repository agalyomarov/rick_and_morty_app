import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rick_and_morty_app/bloc/character_bloc/character_bloc.dart';
import 'package:rick_and_morty_app/bloc/character_bloc/character_event.dart';
import 'package:rick_and_morty_app/bloc/character_bloc/character_state.dart';
import 'package:rick_and_morty_app/core/constants/app_colors.dart';
import 'package:rick_and_morty_app/core/constants/app_routes.dart';
import 'package:rick_and_morty_app/models/character.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
    context.read<CharacterBloc>().add(CharacterLoadEvent());
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
            onPressed: () {},
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
          if (state is CharacterErrorState) {
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
                      context.read<CharacterBloc>().add(CharacterLoadEvent());
                    },
                    child: Text("Refresh"),
                  ),
                ],
              ),
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
      child: Container(
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
                          "$index : ${character.name}",
                          style: TextStyle(color: AppColors.bodyText, fontWeight: FontWeight.w700, fontSize: 14),
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
      ),
    );
  }
}
