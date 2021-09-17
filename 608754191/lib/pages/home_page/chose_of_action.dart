import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../entity/category.dart';

class ChoseOfAction extends StatefulWidget {
  List<Category> categories;
  final int index;
  final BuildContext dialogContext;
  @required
  ChoseOfAction(
    this.dialogContext,
    this.categories,
    this.index,
  );

  @override
  _ChoseOfActionState createState() => _ChoseOfActionState();
}

const String _titleForBlankScreen = 'No events. Click to create one';

class _ChoseOfActionState extends State<ChoseOfAction> {
  late List<Category> categories;
  late final int index;
  late final BuildContext dialogContext;

  @override
  void initState() {
    categories = widget.categories;
    index = widget.index;
    dialogContext = widget.dialogContext;
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
            const Center(
              child: Text(
                'chose of action',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ListTile(
              title: const Text(
                'Delete',
              ),
              leading: const Icon(
                Icons.clear,
                color: Colors.red,
              ),
              onTap: () {
                Navigator.pop(
                  dialogContext,
                );
                categories.removeAt(
                  index,
                );
              },
            ),
            ListTile(
              title: const Text(
                'Update',
              ),
              leading: const Icon(
                Icons.edit,
                color: Colors.blue,
              ),
              onTap: () async {
                var newCategory = await Navigator.of(context).pushNamed('/add_page') as Category;
                newCategory.listMessages = categories[index].listMessages;
                setState(
                  () {
                    categories.removeAt(
                      index,
                    );
                    categories.insert(
                      index,
                      newCategory,
                    );
                  },
                );
                Navigator.pop(
                  dialogContext,
                );
              },
            ),
            ListTile(
              title: const Text(
                'Info',
              ),
              leading: const Icon(
                Icons.info,
                color: Colors.yellow,
              ),
              onTap: () {
                Navigator.pop(
                  dialogContext,
                );
                _showInfoDialog(
                  context,
                );
              },
            ),
            ListTile(
              title: const Text(
                'Pin/Unpin',
              ),
              leading: const Icon(
                Icons.attach_file,
                color: Colors.green,
              ),
              onTap: () {
                Navigator.pop(
                  dialogContext,
                );
              },
            )
          ],
        ),
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
                      categories[index].iconData,
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
                  subtitle: categories[index].listMessages.isEmpty
                      ? const Text(
                          'No messages',
                        )
                      : Text(
                          DateFormat(
                            'yyyy-MM-dd KK:mm:ss',
                          ).format(
                            categories[index].listMessages.first.time,
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
