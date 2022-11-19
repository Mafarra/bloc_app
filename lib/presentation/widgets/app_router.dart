import 'package:bloc_app/business_logic/cubit/characters_cubit.dart';
import 'package:bloc_app/constants/strings.dart';
import 'package:bloc_app/data/repository/characters_repository.dart';
import 'package:bloc_app/data/web_services/characters_web_services.dart';
import 'package:bloc_app/presentation/screens/charachter_details_screen.dart';
import 'package:bloc_app/presentation/screens/characters_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRouter {
  late CharactersRepository charactersRepository;
  late CharactersCubit charactersCubit;
  AppRouter() {
    charactersRepository = CharactersRepository(CharactersWebServices());
    charactersCubit = CharactersCubit(charactersRepository);
  }
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case characterScreen:
        return MaterialPageRoute(builder: (_) =>  BlocProvider(
          create: (context) => charactersCubit,
          child: const CharactersScreen()));
      case characterDetailsScreen:
        return MaterialPageRoute(
            builder: (_) => const CharactersDetailsScreen());
    }
  }
}