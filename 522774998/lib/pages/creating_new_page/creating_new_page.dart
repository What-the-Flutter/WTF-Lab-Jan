import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../repository/property_page.dart';

import '../../database/database.dart';
import '../../repository/icons_repository.dart';
import 'creating_new_page_cubit.dart';

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
    context.read<CreatingNewPageCubit>().settingsController(widget.page.title);
    context.read<CreatingNewPageCubit>().findIcon(widget.page.icon);
    super.initState();
  }

  bool isFieldEmpty = false;
  final DBHelper _dbHelper = DBHelper();

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
          _inputItem(),
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
          if (!isFieldEmpty) {
            Navigator.pop(
              context,
              widget.page.copyWith(
                icon: context.read<CreatingNewPageCubit>().state.selectionIcon,
                title: context.read<CreatingNewPageCubit>().controller.text,
                creationTime: DateTime.now(),
                lastModifiedTime: DateTime.now(),
                isPin: false,
              ),
            );
          } else {
            Navigator.pop(context);
          }
        },
      ),
    );
  }

  Widget _listOfIcons() {
    return Expanded(
      child: GridView.count(
        crossAxisCount: 4,
        children: List.generate(
          listIcon.length,
          (index) {
            return Center(child: _iconItem(listIcon[index]));
          },
        ),
      ),
    );
  }

  Widget _iconItem(ListItemIcon icon) {
    var index;
    return Center(
      child: GestureDetector(
        onTap: () {
          setState(() {
            for (var i = 0; i < listIcon.length; i++) {
              if (listIcon[i].isSelected == true) {
                listIcon[i].isSelected = false;
              }
            }
            if (icon.isSelected == true) {
              icon.isSelected = false;
            } else {
              icon.isSelected = true;
            }
          });
          for (var i = 0; i < listIcon.length; i++) {
            if (listIcon[i].isSelected == true) {
              index = i;
            }
          }
          context.read<CreatingNewPageCubit>().updateList(index);
        },
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            Icon(
              icon.iconData,
              size: 35,
              color: Theme.of(context).primaryColor,
            ),
            if (icon.isSelected)
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
              controller: context.read<CreatingNewPageCubit>().controller,
              decoration: InputDecoration(
                hintText: 'Add new page',
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: isFieldEmpty
                        ? Colors.red
                        : Theme.of(context).primaryColor,
                  ),
                ),
                border: OutlineInputBorder(borderSide: BorderSide()),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
