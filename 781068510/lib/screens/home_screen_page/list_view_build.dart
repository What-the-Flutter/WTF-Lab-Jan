import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/journal_cubit.dart';
import '../../main.dart';
import '../../models/note_model.dart';
import '../../routes/routes.dart';
import '../add_note_page/add_note_page.dart';
import '../info_page/note_info_page.dart';

class BuildListView extends StatefulWidget {
  @override
  _BuildListView createState() => _BuildListView();
}

class _BuildListView extends State<BuildListView> {
  @override
  Widget build(BuildContext context) {
    //JournalCubit()..addElement(Journal(title: '1',iconIndex: 2,note:[]));
    return BlocBuilder<JournalCubit, List<Journal>>(
        builder: (context, journals) {
      if (journals.isEmpty) {
        return const Center(
          child: Text('Nothing to show'),
        );
      }
      return ListView.builder(
        itemCount: journals.length,
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
                                    listOfIcons[journals[index].iconIndex],
                                  ),
                                ),
                                title: Text(
                                  journals[index].title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25,
                                  ),
                                ),
                              ),
                              ListTile(
                                title: const Text('Number of notes'),
                                trailing:
                                    Text(journals[index].note.length.toString()),
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
                      onTap: () async{
                        await Navigator.of(context).pushNamed(
                          addNotePage,
                          arguments: AddNote(
                            title: journals[index].title,
                            selectedIcon: journals[index].iconIndex,
                            index: index,
                          ),
                        );
                        setState(() {});
                      },
                      leading: const Icon(
                        Icons.edit,
                        color: Colors.blueAccent,
                      ),
                      title: const Text('Edit Page'),
                    ),
                    ListTile(
                      onTap: () {
                        JournalCubit()..deleteJournal(index);
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
                listOfIcons[journals[index].iconIndex],
                size: 30,
              ),
            ),
            title: Text(
              journals[index].title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            subtitle: Text(journals[index].note.isNotEmpty
                ? journals[index].note.last.description
                : 'Entry event'),
            onTap: () {
              Navigator.of(context).pushNamed(
                noteInfoPage,
                arguments: NoteInfo(
                  index: index,
                  journal: journals[index],
                ),
              );
            },
          );
        },
      );
    });
  }
}
