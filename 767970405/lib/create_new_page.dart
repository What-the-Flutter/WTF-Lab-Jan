import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_chat_journal/repository/property_message.dart';
import 'package:my_chat_journal/repository/property_page.dart';
import 'package:provider/provider.dart';

import 'logic/home_screen_cubit.dart';
import 'presentation/theme/theme_model.dart';

class CreateNewPage extends StatefulWidget {
  static const routName = 'createPage';
  final int _index;

  CreateNewPage([this._index]);

  @override
  _CreateNewPageState createState() => _CreateNewPageState(_index);
}

class _CreateNewPageState extends State<CreateNewPage> {
  final _controller = TextEditingController();
  final int _index;
  IconData _iconData = Icons.done;

  _CreateNewPageState([this._index]);

  final List<PropertyLabelEvent> _listIcon = <PropertyLabelEvent>[
    PropertyLabelEvent(Icons.title, true),
    PropertyLabelEvent(Icons.account_balance_wallet),
    PropertyLabelEvent(Icons.fitness_center),
    PropertyLabelEvent(Icons.account_balance),
    PropertyLabelEvent(Icons.fastfood),
    PropertyLabelEvent(Icons.wine_bar),
    PropertyLabelEvent(Icons.monetization_on),
    PropertyLabelEvent(Icons.home),
    PropertyLabelEvent(Icons.attach_money),
    PropertyLabelEvent(Icons.shopping_cart),
    PropertyLabelEvent(Icons.radio),
    PropertyLabelEvent(Icons.videogame_asset_sharp),
    PropertyLabelEvent(Icons.local_laundry_service),
    PropertyLabelEvent(Icons.flag),
    PropertyLabelEvent(Icons.music_note),
    PropertyLabelEvent(Icons.event_seat),
    PropertyLabelEvent(Icons.free_breakfast),
    PropertyLabelEvent(Icons.pets),
    PropertyLabelEvent(Icons.pool),
    PropertyLabelEvent(Icons.book_sharp),
    PropertyLabelEvent(Icons.import_contacts_rounded),
    PropertyLabelEvent(Icons.nature_people),
  ];

  @override
  void initState() {
    _controller.addListener(_changeButton);
    if (_index != null) {
      final page = BlocProvider.of<HomeScreenCubit>(context).eventPages[_index];
      _controller.text = page.title;
      _listIcon[0].isVisible = false;
      for (var i in _listIcon) {
        if (i.iconData == page.icon) {
          i.isVisible = true;
          break;
        }
      }
    }
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var page;
    if (_index != null) {
      page = BlocProvider.of<HomeScreenCubit>(context).eventPages[_index];
    }
    return Scaffold(
      body: Column(
        children: [
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(
              top: 60,
              bottom: 10,
            ),
            child: Text(
              'Create a new Page',
              style: TextStyle(
                color: Colors.black,
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(
              top: 10,
              bottom: 20,
              left: 20,
              right: 20,
            ),
            child: TextField(
              autofocus: true,
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Add new Page',
                labelStyle: TextStyle(
                  color: Colors.orange,
                ),
                border: const OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 40,
              ),
              child: GridView.count(
                crossAxisCount: 4,
                crossAxisSpacing: 30.0,
                mainAxisSpacing: 30.0,
                children: [
                  for (var item in _listIcon) _createIconEvent(item),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 10.0,
        child: Icon(
          _iconData,
          color: Colors.black,
        ),
        onPressed: () {
          var icon = Icons.add;
          for (var i = 0; i < _listIcon.length; i++) {
            if (_listIcon[i].isVisible) {
              icon = _listIcon[i].iconData;
              break;
            }
          }
          if (_index == null) {
            Navigator.pop(
              context,
              PropertyPage(
                icon: icon,
                title: _controller.text,
                messages: <PropertyMessage>[],
              ),
            );
          } else {
            Navigator.pop(
              context,
              page.copyWith(
                icon: icon,
                title: _controller.text,
              ),
            );
          }
        },
      ),
    );
  }

  Widget _createIconEvent(PropertyLabelEvent labelEvent) {
    return Container(
      alignment: Alignment.center,
      width: 50,
      height: 50,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: <Widget>[
          IconButton(
            icon: Icon(
              labelEvent.iconData,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                var i = 0;
                while (!_listIcon[i].isVisible) {
                  i++;
                }
                _listIcon[i].isVisible = false;
                labelEvent.isVisible = !labelEvent.isVisible;
              });
            },
          ),
          if (labelEvent.isVisible)
            Container(
              child: Icon(
                Icons.done,
                color: Colors.white,
                size: 15,
              ),
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
      decoration: BoxDecoration(
        color: Provider.of<ThemeModel>(context).currentTheme.cardColor,
        shape: BoxShape.circle,
      ),
    );
  }

  void _changeButton() {
    setState(() {
      if (_controller.text.isEmpty) {
        _iconData = Icons.close;
      } else {
        _iconData = Icons.done;
      }
    });
  }
}

class ProxyData {
  final IconData iconData;
  final String title;

  ProxyData({this.iconData, this.title});
}

// настроить инкапсуляцию
class PropertyLabelEvent {
  final IconData iconData;
  bool isVisible;

  PropertyLabelEvent(this.iconData, [this.isVisible = false]);
}
