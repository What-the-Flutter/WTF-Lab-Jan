import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/cubit/settings/settings_cubit.dart';

import '../../cubit/home_screen/home_cubit.dart';
import '../../main.dart';
import '../../models/note_model.dart';
import '../../routes/routes.dart';
import '../../routes/routes.dart' as route;

class BuildListView extends StatelessWidget {
  BuildListView({Key? key}) : super(key: key);
  late var textState;

  @override
  Widget build(BuildContext context) {
    context.read<HomeCubit>().init();
    textState =
        BlocProvider.of<SettingsCubit>(context).state.textSize.toDouble();
    return BlocBuilder<HomeCubit, HomeState>(builder: (context, state) {
      if (state.pages.isEmpty) {
        return Center(
          child: Text(
            'Nothing to show',
            style: TextStyle(
              fontSize: textState,
            ),
          ),
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
                      title: Text(
                        'Info',
                        style: TextStyle(
                          fontSize: textState,
                        ),
                      ),
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
                                title: Text(
                                  'Number of notes',
                                  style: TextStyle(
                                    fontSize: textState,
                                  ),
                                ),
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
                      title: Text(
                        'Pin/Unpin Page',
                        style: TextStyle(
                          fontSize: textState,
                        ),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.archive,
                        color: Colors.orangeAccent,
                      ),
                      title: Text(
                        'Archive Page',
                        style: TextStyle(
                          fontSize: textState,
                        ),
                      ),
                    ),
                    ListTile(
                      onTap: () => _editPage(context, index),
                      leading: const Icon(
                        Icons.edit,
                        color: Colors.blueAccent,
                      ),
                      title: Text(
                        'Edit Page',
                        style: TextStyle(
                          fontSize: textState,
                        ),
                      ),
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
                      title: Text(
                        'Delete Page',
                        style: TextStyle(
                          fontSize: textState,
                        ),
                      ),
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
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: textState + 2,
              ),
            ),
            subtitle: Text(
              state.pages[index].lastMessage,
              style: TextStyle(
                fontSize: textState - 2,
              ),
            ),
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
