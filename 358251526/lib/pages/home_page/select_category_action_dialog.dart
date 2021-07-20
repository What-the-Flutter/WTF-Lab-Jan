import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'home_page_cubit.dart';

class SelectCategoryWidgetDialog extends StatelessWidget {
  final List categoriesList;
  final BuildContext dialogContext;
  final int index;

  const SelectCategoryWidgetDialog(
      this.dialogContext, this.categoriesList, this.index,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      elevation: 16,
      child: Container(
        height: 240.0,
        width: 200.0,
        child: ListView(
          children: <Widget>[
            SizedBox(height: 20),
            Center(
              child: Text(
                'Select an action',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20),
            ListTile(
              title: Text('Delete'),
              leading: CircleAvatar(
                foregroundColor: Colors.black54,
                child: Icon(Icons.clear),
              ),
              onTap: () {
                BlocProvider.of<HomePageCubit>(dialogContext)
                    .removeCategory(index);
                Navigator.pop(dialogContext);
              },
            ),
            ListTile(
              title: Text('Update'),
              leading: CircleAvatar(
                  foregroundColor: Colors.black54,
                  child: Icon(Icons.lightbulb)),
              onTap: () async {
                BlocProvider.of<HomePageCubit>(dialogContext).updateCategory(
                  context,
                  index,
                  dialogContext,
                );
              },
            ),
            ListTile(
              title: Text('Info'),
              leading: CircleAvatar(
                  foregroundColor: Colors.black54, child: Icon(Icons.info)),
              onTap: () {
                Navigator.pop(dialogContext);
                _showInfoDialog(context);
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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
          elevation: 16,
          child: Container(
            height: 300.0,
            width: 220.0,
            child: ListView(
              children: <Widget>[
                SizedBox(height: 20),
                ListTile(
                  leading: CircleAvatar(
                      foregroundColor: Colors.black54,
                      child: Icon(categoriesList[index].iconData)),
                  title: Text(categoriesList[index].name),
                ),
                SizedBox(height: 20),
                ListTile(
                  title: Text('Created'),
                  subtitle: Text(DateFormat('yyyy-MM-dd KK:mm:ss')
                      .format(categoriesList[index].dateTime)),
                ),
                SizedBox(height: 10),
                ListTile(
                  title: Text('Last Event'),
                  subtitle: categoriesList[index].events.isEmpty
                      ? Text('No events')
                      : Text(DateFormat('yyyy-MM-dd KK:mm:ss')
                          .format(categoriesList[index].events.first.dateTime)),
                ),
                SizedBox(height: 20),
                Center(
                  child: Container(
                    height: 40.0,
                    width: 50.0,
                    child: ElevatedButton(
                        onPressed: () => Navigator.pop(infoDialogContext),
                        child: Text('Ok')),
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
