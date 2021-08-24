import 'package:flutter/material.dart';
import 'package:notes/screens/add_note_page/add_note_page.dart';

import '../../main.dart';
import '../../routes/routes.dart';

class BuildListView extends StatefulWidget {
  @override
  _BuildListView createState() => _BuildListView();
}

class _BuildListView extends State<BuildListView> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          return ListTile(
            onLongPress: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: const Icon(
                        Icons.info,
                        color: Colors.green,
                      ),
                      title: const Text('Info'),
                      onTap: () {
                        showDialog<String>(
                          context: context,
                          builder: (context) => SimpleDialog(
                            children: [
                              ListTile(
                                leading: CircleAvatar(
                                  child: Icon(
                                    listOfIcons[notes[index].iconIndex],
                                  ),
                                ),
                                title: Text(
                                  notes[index].title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25,
                                  ),
                                ),
                              ),
                              ListTile(
                                title: const Text('Number of notes'),
                                trailing:
                                    Text(notes[index].note.length.toString()),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.attach_file,
                        color: Colors.green[300],
                      ),
                      title: const Text('Pin/Unpin Page'),
                    ),
                    const ListTile(
                      leading: Icon(
                        Icons.archive,
                        color: Colors.orangeAccent,
                      ),
                      title: Text('Archive Page'),
                    ),
                    ListTile(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          addNotePage,
                          arguments: AddNote(
                            title: notes[index].title,
                            selectedIcon: notes[index].iconIndex,
                            index: index,
                          ),
                        );
                      },
                      leading: const Icon(
                        Icons.edit,
                        color: Colors.blueAccent,
                      ),
                      title: const Text('Edit Page'),
                    ),
                    ListTile(
                      onTap: () {
                        notes.removeAt(index);
                        Navigator.pop(context);
                        setState(() {});
                      },
                      leading: const Icon(
                        Icons.delete,
                        color: Colors.redAccent,
                      ),
                      title: const Text('Delete Page'),
                    ),
                  ],
                ),
              );
            },
            contentPadding: const EdgeInsets.all(5),
            leading: CircleAvatar(
              radius: 30,
              // backgroundColor: Colors.yellowAccent,
              child: Icon(
                listOfIcons[notes[index].iconIndex],
                size: 30,
              ),
            ),
            title: Text(
              notes[index].title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            subtitle: Text(notes[index].note.isNotEmpty
                ? notes[index].note.last.description
                : 'Entry event'),
            onTap: () {
              Navigator.of(context)
                  .pushNamed(noteInfoPage, arguments: notes[index]);
            },
          );
        });
  }
}
