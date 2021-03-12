import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../app_theme_state.dart';
import '../data/icon_list.dart';
import '../entity/page.dart';
import 'edit_cubit.dart';
import 'edit_state.dart';

class EditPage extends StatefulWidget {
  EditPage(this._page, this._title, this._appThemeState);

  final AppThemeState _appThemeState;
  final JournalPage _page;
  final String _title;

  @override
  _EditPageState createState() => _EditPageState(_page, _title, _appThemeState);
}

class _EditPageState extends State<EditPage> {
  final AppThemeState _appThemeState;
  final String _title;
  final _controller = TextEditingController();
  EditCubit _cubit;

  _EditPageState(JournalPage page, this._title, this._appThemeState) {
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
      cubit: _cubit,
      builder: (context, state) {
        return Scaffold(
          appBar: _appBar,
          body: _body,
          backgroundColor: _appThemeState.mainColor,
        );
      },
    );
  }

  Widget get _appBar {
    return AppBar(
      leading: IconButton(
        onPressed: () => Navigator.pop(context, _cubit.state),
        icon: Icon(
          Icons.arrow_back,
          color: _appThemeState.accentTextColor,
        ),
      ),
      backgroundColor: _appThemeState.accentColor,
      actions: [
        IconButton(
          onPressed: () {
            _cubit.renamePage(_controller.text);
            Navigator.pop(context, _cubit.state);
          },
          icon: Icon(
            _cubit.state.isAllowedToSave ? Icons.check : Icons.close,
            color: _appThemeState.accentTextColor,
          ),
        ),
      ],
      title: Text(
        _title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: _appThemeState.accentTextColor,
        ),
      ),
    );
  }

  Widget get _body {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          _pageInfo,
          Expanded(
            child: GridView.extent(
              maxCrossAxisExtent: 60,
              padding: EdgeInsets.all(10),
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
                        backgroundColor: _appThemeState.accentColor,
                        foregroundColor: _appThemeState.accentTextColor,
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
        cursorColor: _appThemeState.accentTextColor,
        style: TextStyle(
          color: _appThemeState.accentTextColor,
          fontWeight: FontWeight.bold,
        ),
        controller: _controller,
        decoration: InputDecoration(
          hintText: 'Write page name...',
          hintStyle: TextStyle(
            color: _appThemeState.accentTextColor.withOpacity(0.5),
          ),
          border: InputBorder.none,
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
        color: _appThemeState.accentColor,
      ),
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.all(5),
      child: Row(
        children: [
          CircleAvatar(
            maxRadius: 20,
            foregroundColor: _appThemeState.accentTextColor,
            backgroundColor: _appThemeState.accentColor,
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
