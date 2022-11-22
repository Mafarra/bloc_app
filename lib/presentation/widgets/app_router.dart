import '../../business_logic/cubit/characters_cubit.dart';
import '../../constants/strings.dart';
import '../../data/repository/characters_repository.dart';
import '../../data/web_services/characters_web_services.dart';
import '../screens/charachter_details_screen.dart';
import '../screens/characters_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/character_model.dart';

class AppRouter {
  late CharactersRepository charactersRepository;
  late CharactersCubit charactersCubit;
  AppRouter() {
    charactersRepository = CharactersRepository(CharactersWebServices());
    charactersCubit = CharactersCubit(charactersRepository);
    //next line  => bad readability
    //charactersCubit = CharactersCubit(CharactersRepository(CharactersWebServices()));
  }
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case characterScreen:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                create: (context) => charactersCubit,
                child: const CharactersScreen()));
      case characterDetailsScreen:
        final character = settings.arguments as Character;
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
              //new cubit 
              create: (context) => CharactersCubit(charactersRepository),
              child: CharactersDetailsScreen(character: character,),
            ));
    }
  }
}
