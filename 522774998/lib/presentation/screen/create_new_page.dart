import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../../logic/label_cubit.dart';
import '../../../logic/screen_creating_page_cubit.dart';
import '../../../repository/property_page.dart';

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

  bool isFieldEmpty = false;

  @override
  Widget build(BuildContext context) {
    final list = context.read<ScreenCreatingPageCubit>().repository.listIcon;
    return Scaffold(
      appBar: AppBar(
        title: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(right: 40),
          child: Text(
            'Create a new page',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          _inputItem(),
          //_listOfIcons(),
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
          if (!isFieldEmpty) {
            Navigator.pop(
              context,
              widget.page.copyWith(
                icon:
                    context.read<ScreenCreatingPageCubit>().state.selectionIcon,
                title: context.read<ScreenCreatingPageCubit>().controller.text,
              ),
            );
          } else {
            Navigator.pop(context);
          }
        },
      ),
    );
  }

  Widget _inputItem() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: TextField(
              controller: context.read<ScreenCreatingPageCubit>().controller,
              decoration: InputDecoration(
                hintText: 'Add new page',
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                  color: isFieldEmpty
                      ? Colors.red
                      : Theme.of(context).primaryColor,
                )),
                border: OutlineInputBorder(borderSide: BorderSide()),
              ),
            ),
          ),
        ],
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
    return BlocBuilder<LabelCubit, LabelState>(
      builder: (context, state) => Stack(
        alignment: Alignment.bottomRight,
        children: <Widget>[
          IconButton(
            icon: Icon(
              label.icon,
              size: 35,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: () {
              context.read<LabelCubit>().checkedLabel(index);
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
                color: Theme.of(context).accentColor,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
      buildWhen: (prevState, curState) => prevState != curState,
    );
  }
}
