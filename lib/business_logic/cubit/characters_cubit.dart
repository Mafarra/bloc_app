import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../data/models/character_model.dart';
import '../../data/models/quote_model.dart';
import '../../data/repository/characters_repository.dart';
part 'characters_state.dart';

class CharactersCubit extends Cubit<CharactersState> {
  final CharactersRepository charactersRepository;
  List<Character> characters = [];
  // List<QuoteModel> quotes = [];

  CharactersCubit(this.charactersRepository) : super(CharactersInitial());

  List<Character> getAllCharacters() {
    charactersRepository.getAllCharacters().then((characters) {
      emit(CharactersLoaded(characters));
      this.characters = characters;
    });
    return characters;
  }
  void getQuotes(String charName) {
    charactersRepository.getAllCharactersQuotes(charName).then((quotes) {
      emit(QuotesLoaded(quotes));
      // this.quotes = quotes;
    });
    // return quotes;
  }
}
