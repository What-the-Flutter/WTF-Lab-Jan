import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/icons.dart';
import '../../../entity/page.dart';

import 'edit_cubit.dart';
import 'edit_state.dart';

class EditPage extends StatefulWidget {
  EditPage(this._page, this._title);

  final JournalPage _page;
  final String _title;

  @override
  _EditPageState createState() => _EditPageState(_page, _title);
}

class _EditPageState extends State<EditPage> {
  late final String _title;
  final _controller = TextEditingController();
  late EditCubit _cubit;

  _EditPageState(JournalPage page, this._title) {
    _cubit = EditCubit(EditState(page, true));
  }

  @override
  void initState() {
    _controller.text = _cubit.state.page.title;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: _cubit,
      builder: (context, state) {
        return Scaffold(
          appBar: _appBar,
          body: _body,
          backgroundColor: Theme.of(context).primaryColor,
        );
      },
    );
  }

  PreferredSizeWidget get _appBar => AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context, _cubit.state),
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).textTheme.bodyText2!.color,
          ),
        ),
        backgroundColor: Theme.of(context).accentColor,
        actions: [
          IconButton(
            onPressed: () {
              _cubit.renamePage(_controller.text);
              Navigator.pop(context, _cubit.state);
            },
            icon: Icon(
              _cubit.state.isAllowedToSave ? Icons.check : Icons.close,
              color: Theme.of(context).textTheme.bodyText2!.color,
            ),
          ),
        ],
        title: Text(
          _title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.bodyText2!.color,
          ),
        ),
      );

  Widget get _body {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _pageInfo,
          Expanded(
            child: GridView.extent(
              maxCrossAxisExtent: 60,
              padding: const EdgeInsets.all(10),
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              children: [
                ...iconList.map(
                  (e) => GestureDetector(
                    onTap: () {
                      _cubit.changeIcon(iconList.indexOf(e));
                    },
                    child: Center(
                      child: CircleAvatar(
                        maxRadius: 30,
                        backgroundColor: Theme.of(context).accentColor,
                        foregroundColor: Theme.of(context).textTheme.bodyText2!.color,
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

  Widget get _pageInfo {
    Widget _textField() {
      return TextField(
        onChanged: _cubit.updateAllowance,
        cursorColor: Theme.of(context).textTheme.bodyText2!.color,
        style: TextStyle(
          color: Theme.of(context).textTheme.bodyText2!.color,
          fontWeight: FontWeight.bold,
        ),
        controller: _controller,
        decoration: InputDecoration(
          hintText: 'Write page name...',
          hintStyle: TextStyle(
            color: Theme.of(context).textTheme.bodyText2!.color!.withOpacity(0.5),
          ),
          border: InputBorder.none,
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(5),
        ),
        color: Theme.of(context).accentColor,
      ),
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.all(5),
      child: Row(
        children: [
          CircleAvatar(
            maxRadius: 20,
            foregroundColor: Theme.of(context).textTheme.bodyText2!.color,
            backgroundColor: Theme.of(context).accentColor,
            child: Icon(
              iconList[_cubit.state.page.iconIndex],
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
