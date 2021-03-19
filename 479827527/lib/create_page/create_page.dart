import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../home_page/home_page.dart';
import '../note_page.dart';
import 'cubit_create_page.dart';
import 'states_create_page.dart';

class CreatePage extends StatefulWidget {
  final List<NotePage> noteList;
  final bool isEditing;
  final int index;

  CreatePage({Key key, this.noteList, this.isEditing, this.index})
      : super(key: key);

  @override
  _CreatePageState createState() =>
      _CreatePageState(noteList, isEditing, index);
}

class _CreatePageState extends State<CreatePage> {
  List<NotePage> noteList;
  final bool isEditing;
  final int index;
  CubitCreatePage cubit;

  _CreatePageState(this.noteList, this.isEditing, this.index) {
    cubit = CubitCreatePage(StatesCreatePage(Icons.airplanemode_active));
  }

  @override
  void initState() {
    if (isEditing) {
      cubit.state.textController.text = noteList[index].title.data;
      cubit.state.focusNode.requestFocus();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      cubit: cubit,
      builder: (context, state) {
        return Scaffold(
          appBar:
              isEditing ? _appBar('Edit event') : _appBar('Create new event'),
          body: _createPageBody,
          floatingActionButton: _floatingActionButton,
        );
      },
    );
  }

  AppBar _appBar(String title) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 20,
        ),
      ),
    );
  }

  FloatingActionButton get _floatingActionButton {
    return FloatingActionButton(
      child: Icon(
        Icons.check,
      ),
      onPressed: () {
        isEditing ? _editEvent() : _createEvent();
        Navigator.pop(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      },
    );
  }

  void _editEvent() {
    noteList[index].title = Text(
      cubit.state.textController.text,
      style: TextStyle(
        fontSize: 20,
      ),
    );
    noteList[index].icon = CircleAvatar(
      child: Icon(cubit.state.selectedIcon),
    );
  }

  void _createEvent() {
    noteList.add(
      NotePage(
        Text(
          cubit.state.textController.text,
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        Text(
          'No events. Click to create one.',
          style: TextStyle(
            fontSize: 15,
          ),
        ),
        CircleAvatar(
          child: Icon(cubit.state.selectedIcon),
        ),
      ),
    );
  }

  Column get _createPageBody {
    return Column(
      children: <Widget>[
        _inputArea,
        _iconsGrid,
      ],
    );
  }

  Widget get _inputArea {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10.0,
        vertical: 10.0,
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.only(right: 15),
            child: Ink(
              child: _circleAvatar(cubit.state.selectedIcon, Colors.green),
            ),
          ),
          Expanded(
            child: TextField(
              controller: cubit.state.textController,
              decoration: InputDecoration(
                hintText: 'Enter name of the page...',
                border: InputBorder.none,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide.none,
                ),
                filled: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Expanded get _iconsGrid {
    return Expanded(
      child: GridView(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          crossAxisSpacing: 20,
          mainAxisSpacing: 3.0,
        ),
        children: <IconButton>[
          IconButton(
            icon: _circleAvatar(
                Icons.airplanemode_active, Theme.of(context).accentColor),
            onPressed: () {
              cubit.setSelectedIcon(Icons.airplanemode_active);
            },
          ),
          IconButton(
            icon: _circleAvatar(
                Icons.school_sharp, Theme.of(context).accentColor),
            onPressed: () {
              cubit.setSelectedIcon(Icons.school_sharp);
            },
          ),
          IconButton(
            icon: _circleAvatar(Icons.search, Theme.of(context).accentColor),
            onPressed: () {
              cubit.setSelectedIcon(Icons.search);
            },
          ),
          IconButton(
            icon: _circleAvatar(
                Icons.emoji_food_beverage, Theme.of(context).accentColor),
            onPressed: () {
              cubit.setSelectedIcon(Icons.emoji_food_beverage);
            },
          ),
          IconButton(
            icon:
                _circleAvatar(Icons.car_rental, Theme.of(context).accentColor),
            onPressed: () {
              cubit.setSelectedIcon(Icons.car_rental);
            },
          ),
        ],
      ),
    );
  }

  CircleAvatar _circleAvatar(IconData icon, Color color) {
    return CircleAvatar(
      child: Icon(
        icon,
        size: 30,
      ),
      backgroundColor: color,
      foregroundColor: Colors.white,
    );
  }
}
