import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../icons.dart';
import '../../note.dart';
import '../home_page/cubit_home_page.dart';
import 'cubit_create_page.dart';
import 'states_create_page.dart';

class CreatePage extends StatefulWidget {
  final Note? note;

  const CreatePage({Key? key, this.note}) : super(key: key);

  @override
  _CreatePageState createState() => _CreatePageState(note);
}

class _CreatePageState extends State<CreatePage> {
  final TextEditingController textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final Note? _note;

  _CreatePageState(this._note);

  @override
  void initState() {
    super.initState();
    if (_note != null) {
      textController.text = _note!.eventName;
      _focusNode.requestFocus();
      BlocProvider.of<CubitCreatePage>(context).setEditing(true);
      BlocProvider.of<CubitCreatePage>(context)
          .setSelectedIndex(_note!.indexOfCircleAvatar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CubitCreatePage, StatesCreatePage>(
      builder: (context, state) {
        return Scaffold(
          appBar: _appBar(state),
          body: _createPageBody(state),
          floatingActionButton: _floatingActionButton(state),
        );
      },
    );
  }

  AppBar _appBar(StatesCreatePage state) {
    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: true,
      title: state.isEditing
          ? const Text('Edit a Page')
          : const Text('Create a new Page'),
    );
  }

  Widget _createPageBody(StatesCreatePage state) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Container(
            child: _bottomRowWithTextField(state),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 30,
                mainAxisSpacing: 30,
              ),
              itemCount: iconsList.length,
              itemBuilder: (context, index) => _iconButton(index),
            ),
          ),
        ],
      ),
    );
  }

  Row _bottomRowWithTextField(StatesCreatePage state) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          child: _iconButton(state.selectedIndex),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Enter name of the Page',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                filled: false,
              ),
              controller: textController,
              focusNode: _focusNode,
              onChanged: (value) {
                value.isNotEmpty
                    ? BlocProvider.of<CubitCreatePage>(context).setWriting(true)
                    : BlocProvider.of<CubitCreatePage>(context)
                        .setWriting(false);
              },
            ),
          ),
        ),
      ],
    );
  }

  IconButton _iconButton(int index) {
    return IconButton(
      onPressed: () {
        BlocProvider.of<CubitCreatePage>(context).setSelectedIndex(index);
        BlocProvider.of<CubitCreatePage>(context).setWriting(true);
      },
      icon: CircleAvatar(
        child: iconsList[index],
      ),
    );
  }

  FloatingActionButton _floatingActionButton(StatesCreatePage state) {
    return FloatingActionButton(
      child: state.isWriting
          ? const Icon(
              Icons.check,
            )
          : const Icon(
              Icons.clear,
            ),
      onPressed: () {
        if (state.isWriting) {
          if (state.isEditing) {
            _note!.eventName = textController.text;
            _note!.indexOfCircleAvatar = state.selectedIndex;
            BlocProvider.of<CubitCreatePage>(context).setEditing(false);
          } else {
            BlocProvider.of<CubitHomePage>(context)
                .addNote(textController.text, state.selectedIndex);
          }
          Navigator.pop(context);
          BlocProvider.of<CubitCreatePage>(context).setSelectedIndex(0);
          BlocProvider.of<CubitCreatePage>(context).setWriting(false);
        } else {
          Navigator.pop(context);
          BlocProvider.of<CubitCreatePage>(context).setSelectedIndex(0);
          BlocProvider.of<CubitCreatePage>(context).setWriting(false);
          BlocProvider.of<CubitCreatePage>(context).setEditing(false);
        }
      },
    );
  }
}
