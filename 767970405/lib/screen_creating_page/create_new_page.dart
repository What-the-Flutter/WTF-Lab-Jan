import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../data/theme/custom_theme.dart';
import '../settings_screen/visual_setting_cubit.dart';
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
          buildWhen: (prev, cur) => prev.iconButton != cur.iconButton,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _listIcons() {
    return BlocBuilder<ScreenCreatingPageCubit, ScreenCreatingPageState>(
      builder: (context, state) {
        final generalOptionState = context.read<VisualSettingCubit>().state;
        final curTheme = CategoryTheme(
          backgroundColor: generalOptionState.categoryBackgroundColor,
          iconColor: generalOptionState.categoryIconColor,
        );
        return GridView.count(
          crossAxisCount: 4,
          crossAxisSpacing: 30.0,
          mainAxisSpacing: 30.0,
          children: <Widget>[
            for (var i = 0; i < state.list.length; i++)
              CategoryPreviewChat(
                index: i,
                isSelected: state.list[i].isSelected,
                theme: curTheme,
              ),
          ],
        );
      },
      buildWhen: (prevState, curState) =>
          curState.selectionIconIndex != prevState.selectionIconIndex,
    );
  }
}

class CategoryPreviewChat extends StatelessWidget {
  final int index;
  final bool isSelected;
  final CategoryTheme theme;

  const CategoryPreviewChat({
    Key key,
    this.index,
    this.theme,
    this.isSelected,
  }) : super(key: key);

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
              color: theme.iconColor,
            ),
            onPressed: () {
              context.read<ScreenCreatingPageCubit>().selectionIcon(index);
            },
          ),
          if (isSelected)
            Container(
              child: Icon(
                Icons.done,
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
        color: theme.backgroundColor,
        shape: BoxShape.circle,
      ),
    );
  }
}
