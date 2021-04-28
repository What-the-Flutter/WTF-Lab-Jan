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
              color: Theme.of(context).primaryColorLight,
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
                return ListTile(
                  leading: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).primaryColor,
                    ),
                    child: notes[index].icon,
                  ),
                  title: Text(notes[index].title),
                  subtitle: Text(notes[index].subtitle),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EventScreen(
                        title: notes[index].title,
                        note: notes[index],
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
