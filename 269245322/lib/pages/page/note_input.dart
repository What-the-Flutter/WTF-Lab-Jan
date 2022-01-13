import 'package:flutter/material.dart';
import '../../models/note_icon_menu_model.dart';
import 'note_qubit.dart';

List<NoteMenuItem> noteMenuItemList = const [
  NoteMenuItem('test', Icons.ac_unit),
  NoteMenuItem('test', Icons.subject),
  NoteMenuItem('test', Icons.not_interested),
  NoteMenuItem('test', Icons.ac_unit),
  NoteMenuItem('test', Icons.ac_unit),
  NoteMenuItem('test', Icons.ac_unit),
  NoteMenuItem('test', Icons.ac_unit),
  NoteMenuItem('test', Icons.ac_unit),
  NoteMenuItem('test', Icons.ac_unit),
  NoteMenuItem('test', Icons.ac_unit),
  NoteMenuItem('test', Icons.ac_unit),
  NoteMenuItem('test', Icons.ac_unit),
];

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
            ? Row(
                children: [
                  SizedBox(
                    width: 50.0,
                    height: 50.0,
                    child: IconButton(
                      onPressed: () => widget.noteCubit.showNoteIconMenu(false),
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
                            onTap: () => widget.noteCubit
                                .setNewIcon(noteMenuItemList[index].iconData),
                            title: Icon(
                              noteMenuItemList[index].iconData,
                            ),
                            subtitle: Text(
                              noteMenuItemList[index].iconText,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              )
            : Row(
                children: <Widget>[],
              ),
        Row(
          children: [
            Expanded(
              flex: 1,
              child: IconButton(
                icon: const Icon(
                  Icons.image,
                  color: Colors.blue,
                ),
                onPressed: () => widget.noteCubit.showNoteIconMenu(true),
              ),
            ),
            Expanded(
              flex: 6,
              child: Container(
                padding: const EdgeInsets.all(5.0),
                child: TextField(
                  controller: widget.controller,
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
                    onPressed: () =>
                        widget.noteCubit.addNoteToList(widget.controller))),
          ],
        ),
      ],
    );
  }
}
