import 'package:flutter/material.dart';

import 'home_screen.dart';

class AddNote extends StatefulWidget {
  @override
  _AddNote createState() =>
      _AddNote(description: '', title: '', colorFAB: Colors.black12);
}

class _AddNote extends State<AddNote> {
  Color colorFAB;
  String title;
  String description;

  _AddNote(
      {required this.colorFAB, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(
                context,
                MaterialPageRoute(
                  builder: (context) => MainPage(
                    isChangedTheme: () {},
                  ),
                ),
              );
            }),
        title: const Text(
          'Add note',
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
              padding: const EdgeInsets.all(16),
              child: TextFormField(
                autofocus: true,
                onChanged: (text) {
                  if (text != '') {
                    setState(() {
                      title = text;
                      colorFAB = Colors.green;
                    });
                  } else {
                    setState(() {
                      title = text;
                      colorFAB = Colors.grey;
                    });
                  }
                },
                keyboardType: TextInputType.text,
                maxLines: 1,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Title of your note',
                  helperText: '*required field, keep it short',
                  helperStyle: TextStyle(color: Colors.blue),
                  labelText: 'Title',
                  contentPadding: EdgeInsets.all(10),
                ),
              )),
          Container(
            padding: const EdgeInsets.all(16),
            child: TextFormField(
              autofocus: false,
              onChanged: (text) {
                setState(() {
                  if (text != '') {
                    description = text;
                  } else {
                    description = '';
                  }
                });
              },
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Write something',
                labelText: 'Description',
                contentPadding: EdgeInsets.all(10),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.check,
          color: Colors.white,
        ),
        backgroundColor: colorFAB,
        onPressed: () {
          if (colorFAB == Colors.green) {
            setState(() {
              // Add data to notes
            });
            Navigator.pop(
              context,
              MaterialPageRoute(
                builder: (context) => MainPage(
                  isChangedTheme: () {},
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
