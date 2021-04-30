import 'package:flutter/material.dart';

import '../../constants/constants.dart';
import '../../models/note.dart';

class AddNoteScreen extends StatefulWidget {
  @override
  _AddNoteScreenState createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text('New note'),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(
          Icons.check,
          color: Colors.white,
        ),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(kDefaultPadding),
            child: TextFormField(
              keyboardType: TextInputType.name,
              autofocus: false,
              decoration: InputDecoration(
                hintText: 'Enter note title',
                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 4,
              children: List.generate(iconsList.length, (index) {
                return Center(
                  child: CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor,
                    radius: 30.0,
                    child: iconItem(icons[index]),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget iconItem(ListItemIcon icon) {
    var iconColor = Colors.white;
    return Center(
      child: GestureDetector(
        onTap: () {
          setState(() {
            for (var i = 0; i < icons.length; i++) {
              if (icons[i].isSelected == true) {
                icons[i].isSelected = false;
              }
            }
            if (icon.isSelected == true) {
              icon.isSelected = false;
            } else {
              icon.isSelected = true;
            }
          });
        },
        child: Icon(
          icon.icon,
          size: 35,
          color: icon.isSelected ? Theme.of(context).accentColor : iconColor,
        ),
      ),
    );
  }
}
