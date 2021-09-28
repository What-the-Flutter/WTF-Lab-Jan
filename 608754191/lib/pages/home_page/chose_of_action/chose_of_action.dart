import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../entity/category.dart';
import 'chose_of_action_cubit.dart';

class ChoseOfAction extends StatefulWidget {
  List<Category> initialCategories;
  final int index;

  ChoseOfAction(
    this.initialCategories,
    this.index,
  );

  @override
  _ChoseOfActionState createState() => _ChoseOfActionState();
}

class _ChoseOfActionState extends State<ChoseOfAction> {
  late List<Category> _categories;

  @override
  void initState() {
    _categories = widget.initialCategories;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChoseOfActionCubit(widget.initialCategories, widget.index),
      child: BlocBuilder<ChoseOfActionCubit, ChoseOfActionState>(
        builder: (blocContext, state) {
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
              child: ListView(
                children: <Widget>[
                  const SizedBox(
                    height: 20,
                  ),
                  _text(),
                  const SizedBox(
                    height: 30,
                  ),
                  _delete(),
                  _update(),
                  _info(),
                  _pinUnpin(),
                ],
              ),
            ),
          );
        },
      ),
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

  ListTile _delete() {
    return ListTile(
      title: const Text(
        'Delete',
      ),
      leading: const Icon(
        Icons.clear,
        color: Colors.red,
      ),
      onTap: () {
        BlocProvider.of<ChoseOfActionCubit>(context).removeCategory(context, widget.index);
      },
    );
  }

  ListTile _update() {
    return ListTile(
      title: const Text(
        'Update',
      ),
      leading: const Icon(
        Icons.edit,
        color: Colors.blue,
      ),
      onTap: () =>
          BlocProvider.of<ChoseOfActionCubit>(context).update(context, _categories, widget.index),
    );
  }

  ListTile _info() {
    return ListTile(
      title: const Text(
        'Info',
      ),
      leading: const Icon(
        Icons.info,
        color: Colors.yellow,
      ),
      onTap: () {
        Navigator.pop(
          context,
        );
        _showInfoDialog(
          context,
        );
      },
    );
  }

  ListTile _pinUnpin() {
    return ListTile(
      title: const Text(
        'Pin/Unpin',
      ),
      leading: const Icon(
        Icons.attach_file,
        color: Colors.green,
      ),
      onTap: () => Navigator.pop(
        context,
      ),
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
                      _categories[widget.index].iconData,
                    ),
                  ),
                  title: Text(
                    _categories[widget.index].title,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ListTile(
                  title: const Text(
                    'Last message',
                  ),
                  subtitle: _categories[widget.index].listMessages.isEmpty
                      ? const Text(
                          'No messages',
                        )
                      : Text(
                          DateFormat(
                            'yyyy-MM-dd KK:mm:ss',
                          ).format(
                            _categories[widget.index].listMessages.first.time,
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
                      onPressed: () => Navigator.pop(infoDialogContext),
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
