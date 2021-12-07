import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'add_page_cubit.dart';
import 'add_page_state.dart';

class AddPageScreen extends StatefulWidget {
  final bool isEditing;
  final int? selectedPageIndex;

  const AddPageScreen({
    Key? key,
    required this.isEditing,
    this.selectedPageIndex,
  }) : super(key: key);

  @override
  _AddPageScreen createState() => _AddPageScreen();
}

class _AddPageScreen extends State<AddPageScreen> {
  final _pageInputController = TextEditingController();
  final List<IconData> _iconData = const [
    Icons.airplane_ticket,
    Icons.weekend,
    Icons.sports_baseball_sharp,
    Icons.airplane_ticket,
    Icons.weekend,
    Icons.sports_baseball_sharp,
    Icons.airplane_ticket,
    Icons.weekend,
    Icons.sports_baseball_sharp,
    Icons.airplane_ticket,
    Icons.weekend,
    Icons.sports_baseball_sharp,
    Icons.airplane_ticket,
    Icons.weekend,
    Icons.sports_baseball_sharp,
    Icons.airplane_ticket,
    Icons.weekend,
    Icons.sports_baseball_sharp,
    Icons.airplane_ticket,
    Icons.weekend,
    Icons.sports_baseball_sharp,
    Icons.airplane_ticket,
    Icons.weekend,
    Icons.sports_baseball_sharp,
    Icons.airplane_ticket,
    Icons.weekend,
    Icons.sports_baseball_sharp,
  ];

  @override
  void initState() {
    super.initState();
    BlocProvider.of<AddPageCubit>(context).init();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddPageCubit, AddPageState>(
      builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          body: Padding(
            child: _bodyStructure(state),
            padding:
            EdgeInsets.only(bottom: MediaQuery
                .of(context)
                .viewInsets
                .top),
          ),
          floatingActionButton: _pageInputController.text.isEmpty
              ? _cancelButton()
              : _confirmButton(),
        );
      },
    );
  }

  FloatingActionButton _cancelButton() {
    return FloatingActionButton(
      onPressed: () => Navigator.of(context).pop(false),
      child: const Icon(Icons.close, color: Colors.brown),
      backgroundColor: Colors.amberAccent,
    );
  }

  FloatingActionButton _confirmButton() {
    return FloatingActionButton(
      onPressed: () {
        if (widget.isEditing) {
          BlocProvider.of<AddPageCubit>(context).edit(
            _pageInputController.text,
            _iconData,
            widget.selectedPageIndex!,
          );
        } else {
          BlocProvider.of<AddPageCubit>(context)
              .addPage(_pageInputController.text, _iconData);
        }
        Navigator.of(context).pop();
      },
      child: const Icon(Icons.check, color: Colors.brown),
      backgroundColor: Colors.amberAccent,
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _pageInputController.dispose();
    super.dispose();
  }

  Widget _bodyStructure(AddPageState state) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.fromLTRB(15, 40, 15, 10),
        child: Column(
          children: [
            const Text(
              'Create a new Page',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 15),
            _textFormField(state),
            Expanded(
              child: GridView.builder(
                itemCount: _iconData.length,
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: 25,
                  mainAxisSpacing: 30,
                  crossAxisCount: 4,
                ),
                itemBuilder: (context, index) =>
                    GridTile(
                      child: _activityPageIcon(_iconData[index], index, state),
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextFormField _textFormField(AddPageState state) {
    return TextFormField(
      autofocus: true,
      decoration: const InputDecoration(
        border: InputBorder.none,
        contentPadding: EdgeInsets.all(15),
        isDense: true,
        hintText: 'Name of the Page',
        hintStyle: TextStyle(fontSize: 15.0, color: Colors.amberAccent),
        fillColor: Colors.blueGrey,
        filled: true,
      ),
      keyboardType: TextInputType.text,
      controller: _pageInputController,
    );
  }

  Widget _activityPageIcon(IconData iconData, int index, AddPageState state) {
    return CircleAvatar(
      backgroundColor: Colors.grey,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: IconButton(
              icon: Icon(iconData),
              iconSize: 30,
              color: Colors.white,
              onPressed: () =>
                  BlocProvider.of<AddPageCubit>(context).setIconIndex(index),
            ),
          ),
          if (index == state.selectedIconIndex)
            const Align(
              alignment: Alignment.bottomRight,
              child: CircleAvatar(
                radius: 10,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.check_circle,
                  color: Colors.green,
                ), // change this children
              ),
            ),
        ],
      ),
    );
  }
}