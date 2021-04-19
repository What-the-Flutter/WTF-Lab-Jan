import 'package:flutter/material.dart';
import 'homepage.dart';

class CreateNewPage extends StatefulWidget {
  @override
  _CreateNewPageState createState() => _CreateNewPageState();
}

class _CreateNewPageState extends State<CreateNewPage> {
  TextEditingController createpagecontroller = TextEditingController();
  bool isEditing = true;

  void _createPage() {
    setState(() {
      notes.add(Notes(
        notesIcon: Icons.access_alarm,
        notesTitle: createpagecontroller.text,
        notesSubtitle: 'No events. Click to create one.',
      ));
      createpagecontroller.clear();
      Navigator.pop(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ));
    });
  }

  void _editPage() {
    //createpagecontroller.text = notes[index].notesTitle;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create a new Page')),
      body: Column(children: <Widget>[
        Text(
          'Create a new Page',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        TextField(
          controller: createpagecontroller,
          decoration: InputDecoration(
            hintText: 'Enter event',
            border: OutlineInputBorder(
              borderSide: BorderSide(width: 2),
              borderRadius: BorderRadius.all(
                Radius.circular(30.0),
              ),
            ),
          ),
        ),
      ]),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _createPage();
          // Navigator.pop(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => HomePage(),
          //     ));
        },
      ),
    );
  }
}
