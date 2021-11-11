import 'package:flutter/material.dart';
import 'model/event.dart';
import 'model/page.dart' as page;

class CreateNewPage extends StatefulWidget {
  @override
  _CreateNewPageState createState() => _CreateNewPageState();
}

class _CreateNewPageState extends State<CreateNewPage> {
  final _pageInputController = TextEditingController();
  final List<Event> _eventList = [];
  final int _pageIndex = 0;
  Icon _selectedPageIcon = const Icon(Icons.airplane_ticket);
  DateTime _creationDate = DateTime.now();
  int _pageId = 0;
  String _pageName = '';
  int _selectedIndex = 0;

  final List<Icon> _icon = const [
    Icon(Icons.airplane_ticket),
    Icon(Icons.weekend),
    Icon(Icons.sports_baseball_sharp),
    Icon(Icons.airplane_ticket),
    Icon(Icons.weekend),
    Icon(Icons.sports_baseball_sharp),
    Icon(Icons.airplane_ticket),
    Icon(Icons.weekend),
    Icon(Icons.sports_baseball_sharp),
    Icon(Icons.airplane_ticket),
    Icon(Icons.weekend),
    Icon(Icons.airplane_ticket),
    Icon(Icons.weekend),
    Icon(Icons.sports_baseball_sharp),
    Icon(Icons.airplane_ticket),
    Icon(Icons.airplane_ticket),
    Icon(Icons.weekend),
    Icon(Icons.sports_baseball_sharp),
    Icon(Icons.airplane_ticket),
    Icon(Icons.weekend),
    Icon(Icons.sports_baseball_sharp),
    Icon(Icons.airplane_ticket),
    Icon(Icons.weekend),
    Icon(Icons.sports_baseball_sharp),
    Icon(Icons.airplane_ticket),
    Icon(Icons.weekend),
    Icon(Icons.airplane_ticket),
    Icon(Icons.weekend),
    Icon(Icons.sports_baseball_sharp),
    Icon(Icons.airplane_ticket),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Padding(
        child: _bodyStructure(),
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.top),
      ),
      floatingActionButton: _pageInputController.text.isEmpty
          ? FloatingActionButton(
        onPressed: () {
          if (_pageName.isEmpty) {
            Navigator.of(context).pop(false);
          }
        },
        child: const Icon(Icons.close, color: Colors.brown),
        backgroundColor: Colors.amberAccent,
      )
          : FloatingActionButton(
        onPressed: () {
          _pageId++;
          _pageName = _pageInputController.text;
          _selectedPageIcon = _icon[_selectedIndex];
          _creationDate = DateTime.now();
          Navigator.pop(
              context,
              page.Page(_pageId, _pageName, _selectedPageIcon,
                  _creationDate, _eventList));
        },
        child: const Icon(Icons.check, color: Colors.brown),
        backgroundColor: Colors.amberAccent,
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _pageInputController.dispose();
    super.dispose();
  }

  String _changeName(String text) {
    var inputText = '';
    setState(() => inputText = text);
    return inputText;
  }

  Widget _bodyStructure() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.fromLTRB(15, 40, 15, 10),
        child: Column(
          children: [
            const Text(
              'Create a new Page',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 15),
            TextFormField(
              autofocus: true,
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(15),
                isDense: true,
                hintText: 'Name of the Page',
                hintStyle: TextStyle(fontSize: 15.0, color: Colors.amberAccent),
                //focusColor: Colors.amber,
                fillColor: Colors.blueGrey,
                filled: true,
                //hintStyle: TextStyle(
                //color: Colors.grey,
                //),
              ),
              keyboardType: TextInputType.text,
              controller: _pageInputController,
              onChanged: _changeName,
              onFieldSubmitted: (text) {
                if (_pageName.isEmpty) {
                  _pageName = text;
                  _selectedPageIcon = _icon[_selectedIndex];
                } else {
                  _pageName = text;
                  _selectedPageIcon = _icon[_selectedIndex];
                }
                _pageInputController.clear();
                print('$_pageName, $_selectedPageIcon');
              },
            ),
            Expanded(
              child: GridView.builder(
                itemCount: _icon.length,
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: 25,
                  mainAxisSpacing: 30,
                  crossAxisCount: 4,
                ),
                itemBuilder: (context, index) =>
                    GridTile(child: _activityPageIcon(_icon[index], index)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _activityPageIcon(Icon icon, int index) {
    return CircleAvatar(
      backgroundColor: Colors.grey,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: IconButton(
              icon: icon,
              iconSize: 30,
              color: Colors.white,
              onPressed: () => _onPageAvatarPress(index),
            ),
          ),
          if (index == _selectedIndex)
            const Align(
              alignment: Alignment.bottomRight,
              child: CircleAvatar(
                radius: 10,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.check_circle,
                  color: Colors.green,
                ), // change this children
              ),
            ),
        ],
      ),
    );
  }

  void _onPageAvatarPress(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}