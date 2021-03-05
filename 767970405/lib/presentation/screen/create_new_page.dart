import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../logic/label_cubit.dart';
import '../../logic/screen_creating_page_cubit.dart';
import '../../repository/property_page.dart';
import '../theme/theme_model.dart';

class CreateNewPage extends StatefulWidget {
  static const routName = 'createPage';
  final PropertyPage page;

  CreateNewPage({this.page});

  @override
  _CreateNewPageState createState() => _CreateNewPageState();
}

class _CreateNewPageState extends State<CreateNewPage> {
  @override
  void initState() {
    context
        .read<ScreenCreatingPageCubit>()
        .settingsController(widget.page.title);
    context.read<ScreenCreatingPageCubit>().findIcon(widget.page.icon);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final list = context.read<ScreenCreatingPageCubit>().repository.listIcon;
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
              child: GridView.count(
                crossAxisCount: 4,
                crossAxisSpacing: 30.0,
                mainAxisSpacing: 30.0,
                children: [
                  for (var i = 0; i < list.length; i++)
                    BlocProvider<LabelCubit>(
                      create: (context) {
                        final cubit = LabelCubit(
                          repository: context
                              .read<ScreenCreatingPageCubit>()
                              .repository,
                          isVisible: list[i].isVisible,
                        );
                        context.read<ScreenCreatingPageCubit>().list.add(cubit);
                        return cubit;
                      },
                      child: Category(
                        index: i,
                      ),
                    ),
                ],
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
          Navigator.pop(
            context,
            widget.page.copyWith(
              icon: context.read<ScreenCreatingPageCubit>().state.selectionIcon,
              title: context.read<ScreenCreatingPageCubit>().controller.text,
            ),
          );
        },
      ),
    );
  }
}

class Category extends StatelessWidget {
  final int index;

  const Category({Key key, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final label =
        context.read<ScreenCreatingPageCubit>().repository.listIcon[index];
    return Container(
      alignment: Alignment.center,
      width: 50,
      height: 50,
      child: BlocBuilder<LabelCubit, LabelState>(
        builder: (context, state) => Stack(
          alignment: Alignment.bottomRight,
          children: <Widget>[
            IconButton(
              icon: Icon(
                label.icon,
                color: Colors.white,
              ),
              onPressed: () {
                context.read<LabelCubit>().selectionLabel(index);
                context.read<ScreenCreatingPageCubit>().updateList(index);
              },
            ),
            if (state.isVisible)
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
        buildWhen: (prevState, curState) => prevState != curState,
      ),
      decoration: BoxDecoration(
        color: Provider.of<ThemeModel>(context).currentTheme.cardColor,
        shape: BoxShape.circle,
      ),
    );
  }
}
