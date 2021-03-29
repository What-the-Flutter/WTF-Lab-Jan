import 'package:flutter/material.dart';

import '../../../../data/icon_list.dart';
import 'add_label_cubit.dart';
import 'add_label_state.dart';

class AddLabelPage extends StatefulWidget {
  @override
  _AddLabelPageState createState() => _AddLabelPageState();
}

class _AddLabelPageState extends State<AddLabelPage> {

  final _cubit = AddLabelCubit(AddLabelState(0, false));

  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar,
      body: _body,
    );
  }

  Widget get _appBar => AppBar(
    leading: IconButton(
      onPressed: () => Navigator.pop(context, _cubit.state),
      icon: Icon(
        Icons.arrow_back,
        color: Theme.of(context).textTheme.bodyText2.color,
      ),
    ),
    backgroundColor: Theme.of(context).accentColor,
    actions: [
      IconButton(
        onPressed: () =>
          Navigator.pop(context, _cubit.state),
        icon: Icon(
          _cubit.state.isAllowedToSave ? Icons.check : Icons.close,
          color: Theme.of(context).textTheme.bodyText2.color,
        ),
      ),
    ],
    title: Text(
      'New label',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: Theme.of(context).textTheme.bodyText2.color,
      ),
    ),
  );

  Widget get _body {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          _labelInfo,
          Expanded(
            child: GridView.extent(
              maxCrossAxisExtent: 60,
              padding: EdgeInsets.all(10),
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              children: [
                ...iconList.map(
                      (e) =>
                      GestureDetector(
                        onTap: () {
                          _cubit.changeIcon(iconList.indexOf(e));
                        },
                        child: Center(
                          child: CircleAvatar(
                            maxRadius: 30,
                            backgroundColor: Theme
                                .of(context)
                                .accentColor,
                            foregroundColor:
                            Theme
                                .of(context)
                                .textTheme
                                .bodyText2
                                .color,
                            child: Icon(e),
                          ),
                        ),
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget get _labelInfo {
    Widget _textField() {
      return TextField(
        onChanged: _cubit.updateAllowance,
        cursorColor: Theme
            .of(context)
            .textTheme
            .bodyText2
            .color,
        style: TextStyle(
          color: Theme
              .of(context)
              .textTheme
              .bodyText2
              .color,
          fontWeight: FontWeight.bold,
        ),
        controller: _controller,
        decoration: InputDecoration(
          hintText: 'Write page name...',
          hintStyle: TextStyle(
            color: Theme
                .of(context)
                .textTheme
                .bodyText2
                .color
                .withOpacity(0.5),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Theme
                .of(context)
                .primaryColor, width: 2.0),
          ),
          labelText: 'Label Description',
        ),
      );
    }

    return Container(
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.all(5),
      child: Row(
        children: [
          CircleAvatar(
            maxRadius: 20,
            foregroundColor: Theme
                .of(context)
                .textTheme
                .bodyText2
                .color,
            backgroundColor: Theme
                .of(context)
                .accentColor,
            child: Icon(
              iconList[_cubit.state.selectedIconIndex],
            ),
          ),
          Expanded(
            flex: 5,
            child: _textField(),
          ),
        ],
      ),
    );
  }

}
