import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:task_wtf/main.dart';

import '../../entity/category.dart';
import '../home_page_cubit.dart';

class ChoseOfAction extends StatelessWidget {
  List<Category> categories;
  final int index;

  ChoseOfAction(
    this.categories,
    this.index,
  );

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.blueGrey[100],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          20,
        ),
      ),
      elevation: 16,
      child: Container(
        height: 320.0,
        width: 150.0,
        child: _bodyFromDialog(context),
      ),
    );
  }

  Widget _bodyFromDialog(BuildContext context) {
    return ListView(
      children: <Widget>[
        const SizedBox(
          height: 20,
        ),
        _text(),
        const SizedBox(
          height: 30,
        ),
        _buildAction(
          text: 'delete',
          icon: const Icon(
            Icons.clear,
            color: Colors.red,
          ),
          onTap: () {
            BlocProvider.of<HomePageCubit>(context).deleteCategory(
              categories,
              index,
            );
            Navigator.pop(
              context,
            );
          },
        ),
        // _delete(),
        _buildAction(
          text: 'update',
          icon: const Icon(
            Icons.edit,
            color: Colors.blue,
          ),
          onTap: () {
            BlocProvider.of<HomePageCubit>(context).update(context, categories, index);
            Navigator.pop(
              context,
            );
          },
        ),
        _buildAction(
          text: 'info',
          icon: const Icon(
            Icons.info,
            color: Colors.yellow,
          ),
          onTap: () {
            _showInfoDialog(
              context,
            );
            Navigator.pop(
              context,
            );
          },
        ),

        _buildAction(
          text: 'pin/unpin',
          icon: const Icon(
            Icons.attach_file,
            color: Colors.green,
          ),
          onTap: () => Navigator.pop(
            context,
          ),
        ),
      ],
    );
  }

  Widget _text() {
    return const Center(
      child: Text(
        'chose of action',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildAction({
    required String text,
    required Widget icon,
    VoidCallback? onTap,
  }) {
    return ListTile(
      title: Text(text),
      leading: icon,
      onTap: onTap,
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (infoDialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              40,
            ),
          ),
          elevation: 16,
          child: Container(
            height: 300.0,
            width: 220.0,
            child: ListView(
              children: <Widget>[
                const SizedBox(
                  height: 20,
                ),
                ListTile(
                  leading: CircleAvatar(
                    foregroundColor: Colors.black54,
                    child: Icon(
                      initialIcons[categories[index].iconIndex],
                    ),
                  ),
                  title: Text(
                    categories[index].title,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ListTile(
                  title: const Text(
                    'Last message',
                  ),
                  subtitle: categories[index].subTitleMessage.isEmpty
                      ? const Text(
                          'No messages',
                        )
                      : Text(
                          DateFormat(
                            'yyyy-MM-dd KK:mm:ss',
                          ).format(
                            DateTime.now(),
                          ),
                        ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: Container(
                    height: 40.0,
                    width: 50.0,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(
                        infoDialogContext,
                      ),
                      child: const Text(
                        'Ok',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
