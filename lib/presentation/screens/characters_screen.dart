import 'package:animated_text_kit/animated_text_kit.dart';
import '../../business_logic/cubit/characters_cubit.dart';
import '../../constants/my_colors.dart';
import '../../data/models/character_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';
import '../../constants/strings.dart';
import '../widgets/character_item.dart';

class CharactersScreen extends StatefulWidget {
  const CharactersScreen({super.key});

  @override
  State<CharactersScreen> createState() => _CharactersScreenState();
}

class _CharactersScreenState extends State<CharactersScreen> {
  List<Character> allCharacters = [];
  bool _isSerching = false;
  List<Character> serchedForCharacter = [];
  final __searcedTextController = TextEditingController();
  @override
  void initState() {
    super.initState();
    BlocProvider.of<CharactersCubit>(context).getAllCharacters();
  }

  Widget buildBlocWidget() {
    return BlocBuilder<CharactersCubit, CharactersState>(
        builder: ((context, state) {
      if (state is CharactersLoaded) {
        allCharacters = (state).characters;
        return buildLoadedListWidget();
      } else {
        return showLoadingIndecator();
      }
    }));
  }

  Widget showLoadingIndecator() {
    return const Center(
      child: CircularProgressIndicator(
        color: MyColors.myYellow,
      ),
    );
  }

  Widget buildLoadedListWidget() {
    return serchedForCharacter.isEmpty && _isSerching
        ? Container(
            child: buildCharactersList(),
          )
        : SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              width: double.infinity,
              color: MyColors.myGrey,
              child: Column(
                children: [
                  buildCharactersList(),
                ],
              ),
            ),
          );
  }

  Widget buildCharactersList() {
    if (allCharacters.isEmpty) {
      return SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Image.asset(searchAsset),
      );
    } else if (serchedForCharacter.isEmpty && _isSerching) {
      return SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Image.asset(searchAsset),
      );
    } else {
      return GridView.builder(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          padding: EdgeInsets.zero,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 2 / 3,
            crossAxisSpacing: 1,
            mainAxisSpacing: 1,
          ),
          itemCount: __searcedTextController.text.isEmpty
              ? allCharacters.length
              : serchedForCharacter.length,
          itemBuilder: (context, index) {
            return CharacterItem(
              character: __searcedTextController.text.isEmpty
                  ? allCharacters[index]
                  : serchedForCharacter[index],
            );
          });
    }
  }

  Widget _buildSearcheField() {
    return TextField(
      controller: __searcedTextController,
      cursorColor: MyColors.myGrey,
      decoration: const InputDecoration(
        hintText: 'Find a character...',
        border: InputBorder.none,
        hintStyle: TextStyle(color: MyColors.myGrey, fontSize: 18),
      ),
      style: const TextStyle(color: MyColors.myGrey, fontSize: 18),
      onChanged: (searchedCharacter) {
        addSearchedForItemToSearchedList(searchedCharacter);
      },
    );
  }

  void addSearchedForItemToSearchedList(String searchedCharacter) {
    setState(() {
      serchedForCharacter = allCharacters
          .where((character) =>
              character.name!.toLowerCase().startsWith(searchedCharacter))
          //.contains or .startwith as you like
          .toList();
    });
  }

  List<Widget> _buildAppBarActions() {
    if (_isSerching) {
      return [
        IconButton(
            onPressed: () {
              _clearSearch();
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.close,
              color: MyColors.myGrey,
            )),
      ];
    } else {
      return [
        IconButton(
            onPressed: _startSearching,
            icon: const Icon(
              Icons.search,
              color: MyColors.myGrey,
            ))
      ];
    }
  }

  void _startSearching() {
    ModalRoute.of(context)!
        .addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));
    setState(() {
      _isSerching = true;
    });
  }

  void _stopSearching() {
    _clearSearch();
    setState(() {
      _isSerching = false;
    });
  }

  void _clearSearch() {
    setState(() {
      __searcedTextController.clear();
    });
  }

  Widget _buildAppBarTitle() {
    return const Text(
      "Cahracters",
      style: TextStyle(color: MyColors.myGrey),
    );
  }

  Widget _buildNoInternetConnection() {
    return Center(
      child: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DefaultTextStyle(
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              color:Colors.black,
              shadows: [
                Shadow(
                    blurRadius: 20,
                    color: MyColors.myGrey,
                    offset: Offset(0, 0)),
              ],
            ),
            child: AnimatedTextKit(
              repeatForever: true,
              // pause: const Duration(milliseconds: 1000),
              animatedTexts: [
                FlickerAnimatedText('can\'t connect .. check internet',),
              ],
            )),
              // const Text(
            //   'can\'t connect .. check internet',
            //   style: TextStyle(
            //     fontSize: 22,
            //     color: MyColors.myGrey,
            //   ),
            // ),
            const SizedBox(
              height: 10,
            ),
            Image.asset(noConnectionAsset)
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.myYellow,
        title: _isSerching ? _buildSearcheField() : _buildAppBarTitle(),
        actions: _buildAppBarActions(),
        leading: _isSerching
            ? const BackButton(
                color: MyColors.myGrey,
              )
            : Container(),
      ),
      body: OfflineBuilder(
        connectivityBuilder: (
          BuildContext context,
          ConnectivityResult connectivity,
          Widget child,
        ) {
          final bool connected = connectivity != ConnectivityResult.none;
          if (connected) {
            return buildBlocWidget();
          } else {
            return _buildNoInternetConnection();
          }
        },
        child: showLoadingIndecator(),
      ),
    );
  }
}
