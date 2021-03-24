import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../settings_screen/general_options_cubit.dart';
import 'screen_creating_page_cubit.dart';

class CreateNewPage extends StatelessWidget {
  static const routName = 'createPage';

  CreateNewPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(
              top: 60,
              bottom: 10,
            ),
            child: Text(
              'Create a new Page',
              style: TextStyle(
                color: Colors.black,
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(
              top: 10,
              bottom: 20,
              left: 20,
              right: 20,
            ),
            child: TextField(
              autofocus: true,
              controller: context.read<ScreenCreatingPageCubit>().controller,
              decoration: InputDecoration(
                labelText: 'Add new Page',
                border: const OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 40,
              ),
              child: _listIcons(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 10.0,
        child: BlocBuilder<ScreenCreatingPageCubit, ScreenCreatingPageState>(
          builder: (context, state) => Icon(
            state.iconButton,
          ),
          buildWhen: (prev, cur) {
            if (prev.iconButton != cur.iconButton) {
              return true;
            } else {
              return false;
            }
          },
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _listIcons() {
    return BlocBuilder<ScreenCreatingPageCubit, ScreenCreatingPageState>(
      builder: (context, state) => GridView.count(
        crossAxisCount: 4,
        crossAxisSpacing: 30.0,
        mainAxisSpacing: 30.0,
        children: <Widget>[
          for (var i = 0;
              i < context.read<ScreenCreatingPageCubit>().state.list.length;
              i++)
            Category(index: i),
        ],
      ),
      buildWhen: (prevState, curState) =>
          curState.selectionIconIndex != prevState.selectionIconIndex
              ? true
              : false,
    );
  }
}

class Category extends StatelessWidget {
  final int index;

  const Category({Key key, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 50,
      height: 50,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: <Widget>[
          IconButton(
            icon: Icon(
              context.read<ScreenCreatingPageCubit>().state.list[index].icon,
              //color: Colors.white,
            ),
            onPressed: () {
              context.read<ScreenCreatingPageCubit>().selectionIcon(index);
            },
          ),
          if (context
              .read<ScreenCreatingPageCubit>()
              .state
              .list[index]
              .isVisible)
            Container(
              child: Icon(
                Icons.done,
                //color: Colors.white,
                size: 15,
              ),
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
      decoration: BoxDecoration(
        color: context
            .read<GeneralOptionsCubit>()
            .state
            .currentTheme
            .backgroundCategory,
        shape: BoxShape.circle,
      ),
    );
  }
}
