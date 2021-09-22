import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/home_screen/home_cubit.dart';
import '../../main.dart';
import '../../models/note_model.dart';
import '../../routes/routes.dart';
import '../../routes/routes.dart' as route;

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
                                    pagesIcons[state.pages[index].icon],
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
                                trailing: Text(state.pages[index].lastMessage),
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
                      onTap: () => _editPage(context, index),
                      leading: const Icon(
                        Icons.edit,
                        color: Colors.blueAccent,
                      ),
                      title: const Text('Edit Page'),
                    ),
                    ListTile(
                      onTap: () {
                        context.read<HomeCubit>()
                          ..deletePage(
                            index,
                            state.pages[index].id!,
                          );
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
                pagesIcons[state.pages[index].icon],
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

void _editPage(BuildContext context, int index) async {
  final pagesCubit = context.read<HomeCubit>();
  final pages = pagesCubit.state.pages;
  final page = await Navigator.of(context).popAndPushNamed(
    route.addNotePage,
    arguments: pages[index],
  );
  if (page is PageCategoryInfo) {
    pagesCubit.editPage(index, page);
  }
}
