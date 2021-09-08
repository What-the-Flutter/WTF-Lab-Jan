import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/home_screen/home_cubit.dart';
import '../../routes/routes.dart';
import '../add_note_page/add_note_page.dart';
import '../event_page/note_info_page.dart';

class BuildListView extends StatelessWidget {
  BuildListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<HomeCubit>().init();
    return BlocBuilder<HomeCubit, HomeState>(builder: (context, state) {
      if (state.pages.isEmpty) {
        return const Center(
          child: Text('Nothing to show'),
        );
      }
      return ListView.builder(
        itemCount: state.pages.length,
        itemBuilder: (_, index) {
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
                                    state.pages[index].icon,
                                  ),
                                ),
                                title: Text(
                                  state.pages[index].title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25,
                                  ),
                                ),
                              ),
                              ListTile(
                                title: const Text('Number of notes'),
                                trailing: Text(
                                    state.pages[index].lastMessage),
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
                      onTap: () async {
                        await Navigator.of(context).pushNamed(
                          addNotePage,
                          arguments: AddNote(),
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
                        // PageCubit()..deleteJournal(index);
                        Navigator.pop(context);
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
                state.pages[index].icon,
                size: 30,
              ),
            ),
            title: Text(
              state.pages[index].title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            subtitle: Text(state.pages[index].lastMessage),
            onTap: () {
              Navigator.of(context).pushNamed(
                noteInfoPage,
                arguments: state.pages[index],
              );
            },
          );
        },
      );
    });
  }
}
