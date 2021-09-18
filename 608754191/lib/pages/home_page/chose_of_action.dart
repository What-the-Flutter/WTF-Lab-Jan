import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../entity/category.dart';

class ChoseOfAction extends StatefulWidget {
  List<Category> categories;
  final int index;
  final BuildContext dialogContext;

  ChoseOfAction(
    this.dialogContext,
    this.categories,
    this.index,
  );

  @override
  _ChoseOfActionState createState() => _ChoseOfActionState();
}

class _ChoseOfActionState extends State<ChoseOfAction> {
  late List<Category> _categories;
  late final int _index;
  late final BuildContext _dialogContext;

  @override
  void initState() {
    _categories = widget.categories;
    _index = widget.index;
    _dialogContext = widget.dialogContext;
  }

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
        Navigator.pop(_dialogContext);
        _categories.removeAt(
          _index,
        );
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
      onTap: () async {
        final newCategory = await Navigator.of(context).pushNamed('/add_page') as Category;
        newCategory.listMessages = _categories[_index].listMessages;
        setState(() {
          _categories.removeAt(
            _index,
          );
          _categories.insert(
            _index,
            newCategory,
          );
        });
        Navigator.pop(
          _dialogContext,
        );
      },
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
          _dialogContext,
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
        _dialogContext,
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
                      _categories[_index].iconData,
                    ),
                  ),
                  title: Text(
                    _categories[_index].title,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ListTile(
                  title: const Text(
                    'Last message',
                  ),
                  subtitle: _categories[_index].listMessages.isEmpty
                      ? const Text(
                          'No messages',
                        )
                      : Text(
                          DateFormat(
                            'yyyy-MM-dd KK:mm:ss',
                          ).format(
                            _categories[_index].listMessages.first.time,
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
