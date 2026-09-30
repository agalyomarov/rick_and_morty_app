import 'package:flutter/material.dart';
import 'package:rick_and_morty_app/core/type_def/type_def.dart';

class ErrorMessage extends StatelessWidget {
  final String message;
  final CallbackVoid? onPressed;
  const new({required this.message, this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 10,
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red.shade600),
          ),
          ElevatedButton(onPressed: onPressed, child: Text("Обновить")),
        ],
      ),
    );
  }
}
