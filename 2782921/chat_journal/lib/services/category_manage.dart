import 'package:chat_journal/home_screen/home_cubit.dart';
import 'package:chat_journal/model/title_lists.dart';
import 'package:chat_journal/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<dynamic> customModalBottomSheet(
  BuildContext context,
  int index,
  HomeState state,
) {
  Future<void> _printInfo(BuildContext context) async {
    final select = await showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          children: [
            Expanded(
              child: ListviewItems(
                category: state.categories[index],
                index: index,
              ),
            ),
          ],
        );
      },
    );
    return Navigator.pop(context);
  }

  return showModalBottomSheet(
    context: context,
    builder: (context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: const Icon(
              Icons.info,
            ),
            title: const Text('Info'),
            onTap: () {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  return Container(
                    width: 200,
                    height: 200,
                    child: SimpleDialog(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              child: ListviewItems(
                                category: state.categories[index],
                                index: index,
                              ),
                            ),
                          ],
                        ),
                        const Center(
                          child: Text(
                            'Information about Title',
                            style:
                                TextStyle(fontSize: 20, color: Colors.indigo),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.cancel),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        )
                      ],
                      elevation: 10,
                      backgroundColor: Colors.white,
                    ),
                  );
                },
              );
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.push_pin,
              color: Colors.green,
            ),
            title: const Text('Pin/Unpin Page'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.move_to_inbox_outlined,
              color: Colors.yellow,
            ),
            title: const Text('Archive page'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.edit_outlined,
              color: Colors.blue,
            ),
            title: const Text('Edit'),
            onTap: () {
              create(state, context, state.categories[index].title, index);
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.delete_outlined,
              color: Colors.red,
            ),
            title: const Text('Delete'),
            onTap: () {
              Navigator.pop(context);
              context.read<HomeCubit>().deleteCategory(index);
            },
          ),
        ],
      );
    },
  );
}
