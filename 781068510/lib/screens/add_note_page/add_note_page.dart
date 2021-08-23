import 'package:flutter/material.dart';

import '../../main.dart';
import '../../models/note_model.dart';
import '../../routes/routes.dart';
import 'grid_view.dart';

class AddNote extends StatefulWidget {
  final String? title;
  final int? selectedIcon;
  final int? index;

  AddNote({this.title, this.selectedIcon, this.index});

  @override
  _AddNote createState() => _AddNote();
}

class _AddNote extends State<AddNote> {
  Color colorFAB = Colors.black12;
  String title = '';
  int selectedIcon = 0;
  int index = 0;
  bool isEditMode = false;

  bool isTextTyped = false;
  final TextEditingController _textController = TextEditingController();


  void initText() {
    _textController.addListener(() {
      setState(() {
        title = _textController.text;
        if (title.isEmpty) {
          isTextTyped = false;
        } else {
          isTextTyped = true;
        }
      });
    });
  }

  @override
  void initState() {
    if (widget.title != null && widget.selectedIcon != null &&
        widget.index != null) {
      super.initState();
      isEditMode = true;
      title = widget.title!;
      _textController.text = title;
      index = widget.index!;
      selectedIcon = widget.selectedIcon!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Add note',
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(left: 30, right: 30, top: 30),
            child: TextFormField(
              controller: _textController,
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
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: GridViewBuild(
                selectedIndex: selectedIcon,
                onIconChanged: (value) {
                  selectedIcon = value;
                  setState(() {});
                },
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.check,
          color: Colors.white,
        ),
        backgroundColor: colorFAB,
        onPressed: () {
          if (_textController.text != '') {
            if (isEditMode) {
              notes[index].title = _textController.text;
              notes[index].iconIndex = selectedIcon;
            } else {
              notesList.add(List<Note>.empty(growable: true));
              notes.add(Journal(
                  iconIndex: selectedIcon, title: title, note: notesList.last));
            }
            Navigator.of(context).pop(mainPage);
            setState(() {});
          }
        },
      ),
    );
  }
}
