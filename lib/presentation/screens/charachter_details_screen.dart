// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:bloc_app/business_logic/cubit/characters_cubit.dart';
import 'package:bloc_app/constants/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/character_model.dart';

class CharactersDetailsScreen extends StatelessWidget {
  final Character character;
  const CharactersDetailsScreen({
    Key? key,
    required this.character,
  }) : super(key: key);
  Widget _buildSliverAppBar() {
    return SliverAppBar(
      // collapsedHeight: 90,
      // toolbarHeight: 50,
      // excludeHeaderSemantics: true,
      elevation: 0,
      expandedHeight: 600,
      pinned: true,
      stretch: true,
      backgroundColor: MyColors.myGrey,
      flexibleSpace: FlexibleSpaceBar(
        // centerTitle: true,
        title: Text(
          character.nickname!,
          style: const TextStyle(color: MyColors.myWhite),
          // textAlign: TextAlign.start,
        ),
        background: Hero(
            tag: character.charId ?? 1,
            child: Image.network(
              character.img ?? "",
              fit: BoxFit.cover,
            )),
      ),
    );
  }

  Widget _characterInfo({@required String? title, value}) {
    return RichText(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        children: [
          TextSpan(
            text: title,
            style: const TextStyle(
              color: MyColors.myWhite,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          TextSpan(
            text: value,
            style: const TextStyle(
              color: MyColors.myWhite,
              fontWeight: FontWeight.normal,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider({@required double? endIndent}) {
    return Divider(
      height: 30,
      endIndent: endIndent,
      color: MyColors.myYellow,
      thickness: 2,
    );
  }

  List<Widget> charactersInfoList() {
    return [
      _characterInfo(
          title: 'Job :  ', value: character.occupation!.join(' / ')),
      _buildDivider(endIndent: 310),
      _characterInfo(title: 'Appeared in :  ', value: character.category),
      _buildDivider(endIndent: 230),
      _characterInfo(
          title: 'Seasons :  ', value: character.appearance!.join(' / ')),
      _buildDivider(endIndent: 270),
      _characterInfo(title: 'Status :  ', value: character.status),
      _buildDivider(endIndent: 290),
      character.betterCallSaulAppearance!.isEmpty
          ? Container()
          : _characterInfo(
              title: 'Better Call Saul Seasons :  ',
              value: character.betterCallSaulAppearance!.join(' / ')),
      character.betterCallSaulAppearance!.isEmpty
          ? Container()
          : _buildDivider(endIndent: 120),
      _characterInfo(title: 'Actor/Actress :  ', value: character.name),
      _buildDivider(endIndent: 220),
      const SizedBox(
        height: 20,
      ),
      BlocBuilder<CharactersCubit, CharactersState>(builder: (context, state) {
        return checkIfQuotesAreLoaded(state);
      }),
    ];
  }

  Widget checkIfQuotesAreLoaded(CharactersState state) {
    if (state is QuotesLoaded) {
      return displayRandomQuoteOrEmptySpace(state);
    } else {
      return showLoadingIndecator();
    }
  }

  Widget showLoadingIndecator() {
    return const Center(
      child: CircularProgressIndicator(
        color: MyColors.myYellow,
      ),
    );
  }

  Widget displayRandomQuoteOrEmptySpace(QuotesLoaded state) {
    var quotes = (state).quotes;
    if (quotes.isNotEmpty) {
      int randomQuoteIndex = Random().nextInt(quotes.length - 1);
      return Center(
        child: DefaultTextStyle(
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              color: MyColors.myWhite,
              shadows: [
                Shadow(
                    blurRadius: 20,
                    color: MyColors.myYellow,
                    offset: Offset(0, 0)),
              ],
            ),
            child: AnimatedTextKit(
              repeatForever: true,
              // pause: const Duration(milliseconds: 1000),
              animatedTexts: [
                FlickerAnimatedText(quotes[randomQuoteIndex].quote!),
              ],
            )),
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<CharactersCubit>(context).getQuotes(character.name!);
    return Scaffold(
      backgroundColor: MyColors.myGrey,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverList(
              delegate: SliverChildListDelegate([
            Container(
              margin: const EdgeInsets.fromLTRB(14, 14, 14, 0),
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: charactersInfoList(),
              ),
            ),
            const SizedBox(
              height: 500,
            ),
          ]))
        ],
      ),
    );
  }
}
