import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'creating_new_page_cubit.dart';

class CreateNewPage extends StatelessWidget {
  static const routeName = '/CreatePage';

  CreateNewPage();

  @override
  Widget build(BuildContext context) {
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
          Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 5,
                  child: TextField(
                    controller: context.read<CreatingNewPageCubit>().controller,
                    decoration: InputDecoration(
                      hintText: 'Add new page',
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      border: OutlineInputBorder(borderSide: BorderSide()),
                    ),
                  ),
                ),
              ],
            ),
          ),
          _listOfIcons(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 10.0,
        child: BlocBuilder<CreatingNewPageCubit, CreatingNewPageState>(
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
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _listOfIcons() {
    return Expanded(
      child: BlocBuilder<CreatingNewPageCubit, CreatingNewPageState>(
        builder: (context, state) => GridView.count(
          crossAxisCount: 4,
          children: List.generate(
            context.read<CreatingNewPageCubit>().state.list.length,
            (index) {
              return Category(index: index);
            },
          ),
        ),
        buildWhen: (prevState, curState) =>
            curState.selectionIconIndex != prevState.selectionIconIndex
                ? true
                : false,
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
      child: Stack(
        alignment: Alignment.bottomRight,
        children: <Widget>[
          IconButton(
            icon: Icon(
              context.read<CreatingNewPageCubit>().state.list[index].iconData,
              size: 35,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: () {
              context.read<CreatingNewPageCubit>().selectionIcon(index);
            },
          ),
          if (context.read<CreatingNewPageCubit>().state.list[index].isSelected)
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
    );
  }
}
