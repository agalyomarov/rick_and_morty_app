import 'dart:convert';

import 'package:rick_and_morty_app/core/type_def/type_def.dart';
import 'package:rick_and_morty_app/models/character.dart';
import "package:http/http.dart" as http;

class CharactersService {
  FutureList<Character> getCharacters({required int page}) async {
    final uri = Uri.https("rickandmortyapi.com", "/api/character", {"page": page.toString()});
    final response = await http.get(uri);
    final ListDynamic results = jsonDecode(response.body)['results'];
    await Future.delayed(Duration(seconds: 1));
    return results.map((item) => Character.fromJson(item)).toList();
  }
}
