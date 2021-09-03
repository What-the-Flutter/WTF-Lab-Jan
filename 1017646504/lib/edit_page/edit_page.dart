import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tuple/tuple.dart';

import '../color_theme.dart';
import '../edit_page.dart';
import '../page.dart';
import 'edit_bloc.dart';
import 'edit_event.dart';

class EditPage extends StatefulWidget {
  EditPage({required this.page, required this.title});

  final JournalPage page;
  final String title;

  @override
  _EditPageState createState() => _EditPageState(page, title);
}

class _EditPageState extends State<EditPage> {
  _EditPageState(JournalPage page, this._title) {
    bloc = EditBloc(Tuple2(page, true));
  }

  final String _title;
  final _controller = TextEditingController();

  EditBloc bloc = 0 as EditBloc;///////////////

  @override
  void initState() {
    _controller.text = bloc.state.item1.title;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: bloc,
      builder: (context, state) {
        return Scaffold(
          appBar: _appBar,
          body: _body,
          backgroundColor: ColorThemeData.of(context)!.mainColor,
        );
      },
    );
  }

  PreferredSizeWidget get _appBar {
    return AppBar(
      leading: IconButton(
        onPressed: () =>
            Navigator.pop(context, Tuple2(bloc.state.item1, false)),
        icon: Icon(
          Icons.arrow_back,
          color: ColorThemeData.of(context)!.accentTextColor,
        ),
      ),
      backgroundColor: ColorThemeData.of(context)!.accentColor,
      actions: [
        IconButton(
          onPressed: () {
            bloc.state.item1.title = _controller.text;
            Navigator.pop(context, Tuple2(bloc.state.item1, bloc.state.item2));
          },
          icon: Icon(
            bloc.state.item2 ? Icons.check : Icons.close,
            color: ColorThemeData.of(context)!.accentTextColor,
          ),
        ),
      ],
      title: Text(
        _title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: ColorThemeData.of(context)!.accentTextColor,
        ),
      ),
    );
  }

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
                      bloc.add(IconChanged(e));
                    },
                    child: Center(
                      child: CircleAvatar(
                        maxRadius: 30,
                        backgroundColor: ColorThemeData.of(context)!.accentColor,
                        foregroundColor:
                        ColorThemeData.of(context)!.accentTextColor,
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
        onChanged: (text) {
          bloc.add(AllowanceUpdated(text.isNotEmpty));
        },
        cursorColor: ColorThemeData.of(context)!.accentTextColor,
        style: TextStyle(
          color: ColorThemeData.of(context)!.accentTextColor,
          fontWeight: FontWeight.bold,
        ),
        controller: _controller,
        decoration: InputDecoration(
          hintText: 'Write page name...',
          hintStyle: TextStyle(
            color: ColorThemeData.of(context)!.accentTextColor.withOpacity(0.5),
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
        color: ColorThemeData.of(context)!.accentColor,
      ),
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.all(5),
      child: Row(
        children: [
          CircleAvatar(
            maxRadius: 20,
            foregroundColor: ColorThemeData.of(context)!.accentTextColor,
            backgroundColor: ColorThemeData.of(context)!.accentColor,
            child: Icon(
              bloc.state.item1.icon,
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