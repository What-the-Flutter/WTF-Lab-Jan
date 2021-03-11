import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'home_page.dart';

class AddDialogPage extends StatefulWidget {
  final String controller;
  final String operation;
  final int editingDialog;
  final int editingIcon;

  AddDialogPage({
    Key key,
    this.controller,
    this.operation,
    this.editingDialog,
    this.editingIcon = 0,
  }) : super(key: key);

  @override
  _AddDialogPageState createState() => _AddDialogPageState();
}

class _AddDialogPageState extends State<AddDialogPage> {
  final controller = TextEditingController();

  String hintText = 'Name of the page';
  bool isFieldEmpty = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: myTheme,
      home: Scaffold(
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
          children: <Widget>[
            _inputItem(),
            _listOfIcons(),
          ],
        ),
        floatingActionButton: _floatingActionButton,
      ),
    );
  }

  void _checkFieldIsEmpty() {
    setState(() {
      if (controller.text == '') {
        isFieldEmpty = true;
        hintText = 'Enter the name';
      } else {
        isFieldEmpty = false;
      }
    });
  }

  Widget _inputItem() {
    controller.text = widget.controller;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: hintText,
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

  Widget _listOfIcons() {
    return Expanded(
      child: GridView.count(
        crossAxisCount: 4,
        children: List.generate(iconsList.length, (index) {
          return Center(child: _iconItem(icons[index]));
        }),
      ),
    );
  }

  Widget _iconItem(ListItemIcon icon) {
    var iconColor = Theme.of(context).primaryColor;
    return Center(
      child: GestureDetector(
        onTap: () {
          setState(() {
            for (var i = 0; i < icons.length; i++) {
              if (icons[i].isSelected == true) {
                icons[i].isSelected = false;
              }
            }
            if (icon.isSelected == true) {
              icon.isSelected = false;
            } else {
              icon.isSelected = true;
            }
          });
        },
        child: Icon(
          icon.iconData,
          size: 35,
          color: icon.isSelected ? Colors.orange : iconColor,
        ),
      ),
    );
  }

  FloatingActionButton get _floatingActionButton {
    return FloatingActionButton(
      onPressed: () {
        _checkFieldIsEmpty();
        for (var i = 0; i < iconsList.length; i++) {
          if (icons[i].isSelected == true) {
            if (widget.operation == 'edit') {
              dialogs[widget.editingDialog] = ListItem(
                icons[i].iconData,
                controller.text,
                widget.editingDialog,
                DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now()),
                false,
              );
            } else {
              dialogs.add(
                ListItem(
                  icons[i].iconData,
                  controller.text,
                  dialogs.length,
                  DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now()),
                  false,
                ),
              );
            }
          }
        }
        Navigator.of(context).pop();
      },
      tooltip: 'Add new dialog',
      child: Icon(Icons.done),
      backgroundColor: Colors.orange,
    );
  }
}
