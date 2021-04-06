import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/icon_list.dart';
import '../../../entity/label.dart';
import '../../../labels_cubit.dart';
import '../settings_cubit.dart';
import 'add_label_page/add_label_page.dart';

class LabelsPage extends StatefulWidget {
  @override
  _LabelsPageState createState() => _LabelsPageState();
}

class _LabelsPageState extends State<LabelsPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LabelsCubit, List<Label>>(
      builder: (context, state) => Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).accentColor,
          title: Text(
            'Labels',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.bodyText2.color,
            ),
          ),
        ),
        body: _body(context, state),
        floatingActionButton: FloatingActionButton(
          foregroundColor: Theme.of(context).textTheme.bodyText2.color,
          onPressed: () async {
            final labelInfo = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddLabelPage(Label(0,'')),
              ),
            );
            if (labelInfo.isAllowedToSave) {
              BlocProvider.of<LabelsCubit>(context).add(labelInfo.label);
            }
          },
          backgroundColor: Theme.of(context).accentColor,
          tooltip: 'New label',
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  void _pageModalBottomSheet(BuildContext context, Label label) {
    TextStyle _style() {
      return TextStyle(
        color: Theme.of(context).textTheme.bodyText1.color,
        fontSize: SettingsCubit.calculateSize(context, 15, 20, 30),
      );
    }

    Widget _editTile() {
      return ListTile(
          leading: Icon(
            Icons.edit_outlined,
            color: Theme.of(context).textTheme.bodyText1.color,
          ),
          title: Text(
            'Edit',
            style: _style(),
          ),
          onTap: () async {
            final addState = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddLabelPage(
                  label,
                ),
              ),
            );
            if (addState.isAllowedToSave) {
              print(addState.label.description);
              BlocProvider.of<LabelsCubit>(context)
                  .edit(label, addState.label);
            }
            Navigator.pop(context);
          });
    }

    Widget _deleteTile() {
      return ListTile(
          leading: Icon(
            Icons.delete_outlined,
            color: Theme.of(context).textTheme.bodyText1.color,
          ),
          title: Text(
            'Delete',
            style: _style(),
          ),
          onTap: () {
            BlocProvider.of<LabelsCubit>(context).delete(label);
            Navigator.pop(context);
          });
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).primaryColor,
      builder: (context) {
        return Wrap(
          children: <Widget>[
            _editTile(),
            _deleteTile(),
          ],
        );
      },
    );
  }

  Widget _body(BuildContext context, List<Label> state) {

    return GridView.extent(
      crossAxisSpacing: 2,
      mainAxisSpacing: 2,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      padding: EdgeInsets.all(10),
      maxCrossAxisExtent: 80,
      children: [
        for (var index = 0; index < state.length; index++)
          GestureDetector(
            onTap: () => _pageModalBottomSheet(context, state[index]),
            child: Center(
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundColor: Theme.of(context).accentColor,
                    foregroundColor:
                        Theme.of(context).textTheme.bodyText2.color,
                    child: Icon(iconList[state[index].iconIndex]),
                  ),
                  Expanded(
                    child: Text(
                      state[index].description,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyText1.color,
                        fontSize:
                            SettingsCubit.calculateSize(context, 12, 15, 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
