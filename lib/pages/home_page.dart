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
import 'package:window_manager/window_manager.dart';

class HomePage extends StatefulWidget {
  const new({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WindowListener {
  final ScrollController _scrollController = ScrollController();
  bool isFullScreen = false;

  @override
  void initState() {
    _scrollController.addListener(_onScroll);
    windowManager.addListener(this);
    _loadFullScreenState();
    super.initState();
  }

  void _onScroll() {
    final remainingScrollHeight = _scrollController.position.maxScrollExtent - _scrollController.position.pixels;
    if (remainingScrollHeight <= 0) {
      context.read<CharacterBloc>().add(CharacterLoadEvent());
    }
  }

  Future<void> _loadFullScreenState() async {
    final value = await windowManager.isFullScreen();

    if (!mounted) {
      return;
    }

    setState(() {
      isFullScreen = value;
    });
  }

  Future<void> _toggleMaximize() async {
    final isMaximized = await windowManager.isMaximized();

    if (isMaximized) {
      await windowManager.unmaximize();
      await windowManager.setSize(const Size(800, 600));
      await windowManager.center();
    } else {
      await windowManager.maximize();
    }
  }

  @override
  void onWindowEnterFullScreen() {
    setState(() {
      isFullScreen = true;
    });
  }

  @override
  void onWindowLeaveFullScreen() {
    setState(() {
      isFullScreen = false;
    });
  }

  @override
  void dispose() {
    windowManager.removeListener(this);

    _scrollController
      ..removeListener(_onScroll)
      ..dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(30),
        child: GestureDetector(
          onDoubleTap: _toggleMaximize,
          child: AppBar(
            // title: Text("Characters", style: TextStyle(color: AppColors.bodyText)),
            title: Padding(
              padding: EdgeInsets.only(left: isFullScreen ? 0 : 100),
              child: Row(
                spacing: 20,
                children: [
                  Text("Characters", style: TextStyle(color: AppColors.bodyText)),
                  Text("Characters", style: TextStyle(color: AppColors.bodyText)),
                  Text("Characters", style: TextStyle(color: AppColors.bodyText)),
                  Text("Characters", style: TextStyle(color: AppColors.bodyText)),
                ],
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  context.go(AppRoutes.search());
                },
                icon: Icon(Icons.search, color: AppColors.bodyText, size: 16),
              ),
              SizedBox(width: 10),
            ],
            centerTitle: false,
            backgroundColor: Colors.blue.shade300,
          ),
        ),
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
        context.push(AppRoutes.character(character.id.toString()));
      },
      child: CharacterCard(character: character),
    );
  }
}
