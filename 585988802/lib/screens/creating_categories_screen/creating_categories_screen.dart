import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/font_size_customization.dart';

import '../setting_screen/settings_screen_bloc.dart';
import 'creating_categories_screen_bloc.dart';
import 'creating_categories_screen_event.dart';
import 'creating_categories_screen_state.dart';

class CreatingCategoriesScreen extends StatefulWidget {
  CreatingCategoriesScreen({Key key}) : super(key: key);

  @override
  _CreatingCategoriesScreenState createState() =>
      _CreatingCategoriesScreenState();
}

class _CreatingCategoriesScreenState extends State<CreatingCategoriesScreen> {
  final TextEditingController _textEditingController = TextEditingController();

  _CreatingCategoriesScreenState();

  @override
  void initState() {
    BlocProvider.of<CreatingCategoriesScreenBloc>(context)
        .add(CreatingCategoriesScreenInit());
    super.initState();
  }

  final List<String> _listImagesPath = [
    'assets/images/journal.png',
    'assets/images/pig.png',
    'assets/images/money_invest.png',
    'assets/images/supermarket.png',
    'assets/images/burger.png',
    'assets/images/pasta.png',
    'assets/images/donut.png',
    'assets/images/restaurant.png',
    'assets/images/soup.png',
    'assets/images/snack.png',
    'assets/images/tea.png',
    'assets/images/relax.png',
    'assets/images/beer.png',
    'assets/images/beverage.png',
    'assets/images/bus.png',
    'assets/images/bike.png',
    'assets/images/taxi1.png',
    'assets/images/car.png',
    'assets/images/subway.png',
    'assets/images/airplane.png',
    'assets/images/cats.png',
    'assets/images/dog.png',
    'assets/images/dog1.png',
    'assets/images/parrot.png',
    'assets/images/american_football.png',
    'assets/images/bask.png',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreatingCategoriesScreenBloc,
        CreatingCategoriesScreenState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: _appBar,
          body: _body,
        );
      },
    );
  }

  AppBar get _appBar {
    return AppBar(
      iconTheme: Theme.of(context).iconTheme,
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      title: Container(
        child: Text(
          'Create a new categorie',
          style: TextStyle(
            color: Theme.of(context).secondaryHeaderColor,
            fontSize:
                BlocProvider.of<SettingScreenBloc>(context).state.fontSize == 0
                    ? appBarSmallFontSize
                    : BlocProvider.of<SettingScreenBloc>(context)
                                .state
                                .fontSize ==
                            1
                        ? appBarDefaultFontSizeCrCatOrSugScr
                        : appBarLargeFontSizeCrCatScr,
          ),
        ),
        alignment: Alignment.center,
      ),
      actions: [
        BlocProvider.of<CreatingCategoriesScreenBloc>(context).state.isWriting
            ? IconButton(
                icon: Icon(
                  Icons.check,
                ),
                onPressed: () => Navigator.of(context).pop(),
              )
            : IconButton(
                icon: Icon(
                  Icons.clear,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
      ],
      elevation: 0.0,
    );
  }

  Column get _body {
    return Column(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: _rowInpNewCategorie,
          ),
        ),
        Expanded(
          flex: 7,
          child: _partIconSelection,
        ),
      ],
    );
  }

  Row get _rowInpNewCategorie {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Image(
            image: AssetImage(
              BlocProvider.of<CreatingCategoriesScreenBloc>(context)
                  .state
                  .currentImagePath,
            ),
          ),
        ),
        SizedBox(
          width: 10.0,
        ),
        Expanded(
          flex: 5,
          child: TextField(
            controller: _textEditingController,
            textCapitalization: TextCapitalization.sentences,
            onChanged: (value) {
              BlocProvider.of<CreatingCategoriesScreenBloc>(context).add(
                AddButtonChanged(value.isNotEmpty && value.trim() != ''),
              );
            },
            decoration: InputDecoration(
              hintText: 'Enter name of Categorie',
              hintStyle: TextStyle(
                color: Colors.white70,
              ),
              border: OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                  Radius.circular(25.0),
                ),
                borderSide: BorderSide.none,
              ),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              filled: true,
              fillColor: Colors.white38,
            ),
          ),
        ),
      ],
    );
  }

  ClipRRect get _partIconSelection {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(25.0),
        topRight: Radius.circular(25.0),
      ),
      child: Container(
        padding: EdgeInsets.only(
          left: 10.0,
          right: 10.0,
        ),
        margin: EdgeInsets.only(
          top: 5.0,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.0),
            topRight: Radius.circular(25.0),
          ),
        ),
        child: _iconSelectionGridView,
      ),
    );
  }

  GridView get _iconSelectionGridView {
    return GridView.count(
      crossAxisCount: 4,
      crossAxisSpacing: 10.0,
      mainAxisSpacing: 10.0,
      shrinkWrap: true,
      children: _listImagesPath
          .map((image) => Padding(
                padding: const EdgeInsets.all(6.0),
                child: GestureDetector(
                  onTap: () =>
                      BlocProvider.of<CreatingCategoriesScreenBloc>(context)
                          .add(
                    CurrentImageChanged(image),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(image),
                      ),
                    ),
                  ),
                ),
              ))
          .toList(),
    );
  }
}
