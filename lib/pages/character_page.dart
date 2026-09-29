import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
      body: Placeholder(),
    );
  }
}
