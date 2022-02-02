import 'package:flutter/material.dart';

import '../../main.dart';
import 'note_qubit.dart';

class NoteInput extends StatefulWidget {
  final TextEditingController controller;
  final NoteCubit noteCubit;
  NoteInput({
    Key? key,
    required this.controller,
    required this.noteCubit,
  }) : super(key: key);

  @override
  _NoteInputState createState() => _NoteInputState();
}

class _NoteInputState extends State<NoteInput> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        widget.noteCubit.getShowNoteIconMenueState()
            ? _noteIconMenue(widget.noteCubit, context)
            : Row(
                children: <Widget>[],
              ),
        _textInputPanel(widget.noteCubit, widget.controller, context)
      ],
    );
  }
}

Row _noteIconMenue(NoteCubit noteCubit, BuildContext context) {
  return Row(
    children: [
      SizedBox(
        width: 50.0,
        height: 50.0,
        child: IconButton(
          onPressed: () => noteCubit.showNoteIconMenu(false),
          icon: const Icon(
            Icons.close,
            color: Colors.red,
          ),
        ),
      ),
      Container(
        height: 60.0,
        width: MediaQuery.of(context).size.width - 50.0,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: noteMenuItemList.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return SizedBox.square(
              dimension: 60.0,
              child: ListTile(
                onTap: () => noteCubit.setNewNoteIcon(index),
                title: Icon(
                  noteMenuItemList[index]!.iconData,
                ),
                subtitle: Text(
                  noteMenuItemList[index]!.iconText,
                ),
              ),
            );
          },
        ),
      ),
    ],
  );
}

Row _textInputPanel(NoteCubit noteCubit, TextEditingController controller,
    BuildContext context) {
  return Row(
    children: [
      Expanded(
        flex: 1,
        child: Column(
          children: [
            IconButton(
              icon: const Icon(
                Icons.photo_album,
                color: Colors.blue,
              ),
              onPressed: () {
                showDialog<String>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Upload image'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                                onPressed: noteCubit.selectFile,
                                icon: const Icon(
                                  Icons.photo,
                                  size: 35.0,
                                )),
                            IconButton(
                                onPressed: null,
                                icon: const Icon(
                                  Icons.upload,
                                  size: 35.0,
                                )),
                          ],
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        const Text('data'),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.image,
                color: Colors.blue,
              ),
              onPressed: () => noteCubit.showNoteIconMenu(true),
            ),
          ],
        ),
      ),
      Expanded(
        flex: 6,
        child: Container(
          padding: const EdgeInsets.all(5.0),
          child: TextField(
            controller: controller,
            maxLines: 1,
            maxLength: 50,
            decoration: const InputDecoration(
              hintText: 'new node',
              fillColor: Colors.black12,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
            ),
          ),
        ),
      ),
      Expanded(
          flex: 1,
          child: IconButton(
              icon: const Icon(
                Icons.send,
                color: Colors.blue,
              ),
              onPressed: () => noteCubit.addNoteToList(controller))),
    ],
  );
}
