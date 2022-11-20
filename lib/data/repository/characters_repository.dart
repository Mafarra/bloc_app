import 'package:bloc_app/data/models/quote_model.dart';
import 'package:bloc_app/data/web_services/characters_web_services.dart';

import '../models/character_model.dart';

class CharactersRepository {
  final CharactersWebServices charactersWebServices;

  CharactersRepository(this.charactersWebServices);

  Future<List<Character>> getAllCharacters() async {
    final characters = await charactersWebServices.getAllCharacters();
    return characters
        .map((character) => Character.fromJson(character))
        .toList();
  }
  Future<List<QuoteModel>> getAllCharactersQuotes(String charName) async {
    final quotes = await charactersWebServices.getAllCharactersQuotes(charName);
    return quotes
        .map((quote) => QuoteModel.fromJson(quote))
        .toList();
  }
}
