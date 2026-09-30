import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rick_and_morty_app/bloc/search_bloc/search_bloc.dart';
import 'package:rick_and_morty_app/bloc/search_bloc/search_event.dart';
import 'package:rick_and_morty_app/bloc/search_bloc/search_state.dart';
import 'package:rick_and_morty_app/core/constants/app_colors.dart';
import 'package:rick_and_morty_app/core/constants/app_routes.dart';
import 'package:rick_and_morty_app/widgets/error_message.dart';

class SearchPage extends StatefulWidget {
  const new({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final textEditingController = TextEditingController();
  bool canInput = false;

  @override
  void dispose() {
    EasyDebounce.cancel('debouncer1');
    super.dispose();
  }

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
        title: Text("Search", style: TextStyle(color: AppColors.bodyText)),
        centerTitle: true,
        backgroundColor: AppColors.mainBg,
      ),
      backgroundColor: AppColors.mainBg,
      body: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          final canInput = state is! SearchLoadingState;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 20,
              children: [
                Form(
                  child: Column(
                    children: [
                      TextFormField(
                        enabled: canInput,
                        controller: textEditingController,
                        decoration: InputDecoration(
                          filled: true,
                          border: OutlineInputBorder(),
                          hintText: 'Введите имя персонажа',
                          hintStyle: TextStyle(color: Colors.white30),
                          fillColor: AppColors.cellBg,
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.white54)),
                        ),
                        style: TextStyle(color: Colors.white),
                        onChanged: (value) {
                          EasyDebounce.debounce('debouncer1', Duration(milliseconds: 500), () {
                            if (value.trim().isNotEmpty) {
                              context.read<SearchBloc>().add(SearchEventInputEvent(name: value));
                            }
                          });
                        },
                      ),
                    ],
                  ),
                ),
                buildContent(state),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildContent(SearchState state) {
    if (state is SearchLoadedState) {
      return Expanded(
        child: ListView.separated(
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: GestureDetector(
              onTap: () {
                context.push(AppRoutes.character(state.characters[index].id.toString()));
              },
              child: Text(state.characters[index].name, style: TextStyle(color: Colors.white)),
            ),
          ),
          separatorBuilder: (context, index) => Divider(color: Colors.white24),
          itemCount: state.characters.length,
        ),
      );
    }

    if (state is SearchLoadingState) {
      return Center(child: CircularProgressIndicator());
    }

    if (state is SearchErrorState) {
      return ErrorMessage(message: state.message);
    }
    return SizedBox.shrink();
  }
}
