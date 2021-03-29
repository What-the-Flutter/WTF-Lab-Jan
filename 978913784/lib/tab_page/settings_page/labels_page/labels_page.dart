import 'package:chat_journal/entity/label.dart';
import 'package:chat_journal/tab_page/settings_page/labels_page/labels_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/icon_list.dart';
import '../settings_cubit.dart';
import 'add_label_page/add_label_page.dart';
import 'labels_cubit.dart';

class LabelsPage extends StatefulWidget {
  @override
  _LabelsPageState createState() => _LabelsPageState();
}

class _LabelsPageState extends State<LabelsPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LabelsCubit, LabelsState>(
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
                builder: (context) => AddLabelPage(),
              ),
            );
            if (labelInfo.isAllowedToSave) {
              BlocProvider.of<LabelsCubit>(context).addLabel(labelInfo.label);
            }
          },
          backgroundColor: Theme.of(context).accentColor,
          tooltip: 'New label',
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _body(BuildContext context, LabelsState state) {

    final labelList = <Label>[
      ...labels,
      ...state.added,
    ];

    return GridView.extent(
      crossAxisSpacing: 5,
      mainAxisSpacing: 5,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      padding: EdgeInsets.all(10),
      maxCrossAxisExtent: 100,
      children: [
        for (var index = 0; index < labelList.length; index++)
          GestureDetector(
            onTap: () async {},
            child: Center(
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundColor: Theme.of(context).accentColor,
                    foregroundColor:
                        Theme.of(context).textTheme.bodyText2.color,
                    child: Icon(eventIconList[index]),
                  ),
                  Expanded(
                    child: Text(
                      eventStringList[index],
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
