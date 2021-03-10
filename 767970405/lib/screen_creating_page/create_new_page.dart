import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../data/model/model_page.dart';
import '../data/repository/icons_repository.dart';
import '../data/theme/theme_model.dart';
import 'screen_creating_page_cubit.dart';

class CreateNewPage extends StatelessWidget {
  static const routName = 'createPage';
  final ModelPage page;

  CreateNewPage({this.page});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ScreenCreatingPageCubit>(
      create: (context) => ScreenCreatingPageCubit(
        repository: IconsRepository(),
        title: page.title,
        selectionIconIndex: 0,
        iconButton: Icons.close,
      ),
      child: Builder(
        builder: (context) => Scaffold(
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
                  controller:
                      context.read<ScreenCreatingPageCubit>().controller,
                  decoration: InputDecoration(
                    labelText: 'Add new Page',
                    labelStyle: TextStyle(
                      color: Colors.orange,
                    ),
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 40,
                  ),
                  child: BlocBuilder<ScreenCreatingPageCubit,
                      ScreenCreatingPageState>(
                    builder: (context, state) => GridView.count(
                      crossAxisCount: 4,
                      crossAxisSpacing: 30.0,
                      mainAxisSpacing: 30.0,
                      children: <Widget>[
                        for (var i = 0;
                            i <
                                context
                                    .read<ScreenCreatingPageCubit>()
                                    .state
                                    .list
                                    .length;
                            i++)
                          Category(index: i),
                      ],
                    ),
                    buildWhen: (prevState, curState) =>
                        curState.selectionIconIndex !=
                                prevState.selectionIconIndex
                            ? true
                            : false,
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            elevation: 10.0,
            child: BlocBuilder<ScreenCreatingPageCubit, ScreenCreatingPageState>(
              builder: (context, state) => Icon(
                state.iconButton,
                color: Colors.black,
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
              final state = context.read<ScreenCreatingPageCubit>().state;
              if (state.iconButton == Icons.close) {
                Navigator.pop(context);
              } else {
                Navigator.pop(
                  context,
                  page.copyWith(
                    icon: state.list[state.selectionIconIndex].icon,
                    title:
                    context
                        .read<ScreenCreatingPageCubit>()
                        .controller
                        .text,
                  ),
                );
              }
            },
          ),
        ),
      ),
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
              color: Colors.white,
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
                color: Colors.white,
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
        color: Provider.of<ThemeModel>(context).currentTheme.cardColor,
        shape: BoxShape.circle,
      ),
    );
  }
}
