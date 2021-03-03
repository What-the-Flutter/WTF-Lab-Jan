import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../db_helper/db_helper.dart';
import '../models/category.dart';
import '../theme_provider/custom_theme_provider.dart';

class CreatingCategoriesScreen extends StatefulWidget {
  CreatingCategoriesScreen({Key key}) : super(key: key);

  @override
  _CreatingCategoriesScreenState createState() =>
      _CreatingCategoriesScreenState();
}

class _CreatingCategoriesScreenState extends State<CreatingCategoriesScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  final DBHelper _dbHelper = DBHelper();

  String _currentImagePath = 'assets/images/journal.png';
  bool _isWriting = false;

  _CreatingCategoriesScreenState();

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

  final List<Category> _categoryList = [
    Category(nameOfCategory: 'Journal', imagePath: 'assets/images/journal.png'),
    Category(nameOfCategory: 'Pig', imagePath: 'assets/images/pig.png'),
    Category(
        nameOfCategory: 'Money', imagePath: 'assets/images/money_invest.png'),
    Category(nameOfCategory: 'Tea', imagePath: 'assets/images/tea.png'),
    Category(nameOfCategory: 'Relax', imagePath: 'assets/images/relax.png'),
    Category(nameOfCategory: 'Bar', imagePath: 'assets/images/beer.png'),
    Category(nameOfCategory: 'Bus', imagePath: 'assets/images/bus.png'),
    Category(nameOfCategory: 'Bike', imagePath: 'assets/images/bike.png'),
    Category(nameOfCategory: 'Taxi', imagePath: 'assets/images/taxi1.png'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _appBar,
      body: _body,
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
            color: Provider.of<ThemeProvider>(context).isDarkMode
                ? Theme.of(context).accentColor
                : Theme.of(context).primaryColor,
          ),
        ),
        alignment: Alignment.center,
      ),
      actions: [
        _isWriting
            ? IconButton(
                icon: Icon(
                  Icons.check,
                ),
                onPressed: () {
                  setState(() {});
                },
              )
            : IconButton(
                icon: Icon(
                  Icons.clear,
                ),
                onPressed: () {
                  setState(() => Navigator.of(context).pop());
                },
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
        _isWriting
            ? Container()
            : Expanded(
                flex: 2,
                child: _categoriesList,
              ),
        Expanded(
          flex: 6,
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
            image: AssetImage(_currentImagePath),
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
              (value.isNotEmpty && value.trim() != '')
                  ? isWriting = true
                  : isWriting = false;
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

  set isWriting(bool isWriting) {
    setState(() => _isWriting = isWriting);
  }

  ClipRRect get _categoriesList {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(25.0)),
      child: Container(
        padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
        margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
        child: _categoriesGridView,
      ),
    );
  }

  GridView get _categoriesGridView {
    return GridView.count(
      scrollDirection: Axis.horizontal,
      crossAxisCount: 1,
      crossAxisSpacing: 10.0,
      mainAxisSpacing: 10.0,
      shrinkWrap: true,
      children: _categoryList
          .map((category) => Padding(
                padding: const EdgeInsets.all(6.0),
                child: GestureDetector(
                  onTap: () => setState(() {}),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 3,
                        child: CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 22,
                            child: Image.asset(category.imagePath),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          category.nameOfCategory,
                          style: TextStyle(
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ))
          .toList(),
    );
  }

  ClipRRect get _partIconSelection {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(25.0),
        topRight: Radius.circular(25.0),
      ),
      child: Container(
        padding: EdgeInsets.only(left: 10.0, right: 10.0),
        margin: EdgeInsets.only(top: 5.0),
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
                  onTap: () => setState(() => _currentImagePath = image),
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
