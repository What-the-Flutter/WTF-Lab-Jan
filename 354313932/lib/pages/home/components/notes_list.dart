import 'package:flutter/material.dart';

import '../../../constants/constants.dart';
import '../../../models/note.dart';
import '../../event/event_screen.dart';

class NotesList extends StatelessWidget {
  const NotesList({
    Key key,
    @required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size.height,
      child: Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 16.0),
            padding: EdgeInsets.only(
              top: size.height * 0.12,
              left: kDefaultPadding,
              right: kDefaultPadding,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                Note note;
                note = notes[index];
                return Builder(
                  builder: (context) => GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EventScreen(note: note, title: note.title),
                        ),
                      );
                    },
                    onLongPress: () {
                      //settingModalBottomSheet(context, dialog);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: ListTile(
                        tileColor: Theme.of(context).backgroundColor,
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(context).primaryColor,
                          radius: 30.0,
                          child: Icon(
                            note.isPinned ? Icons.push_pin : note.icon,
                            size: 35.0,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(
                          note.title,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
