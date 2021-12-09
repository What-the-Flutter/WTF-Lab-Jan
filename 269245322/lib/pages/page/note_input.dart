import 'package:flutter/material.dart';

typedef Myfunc = Function(int a, String b);

class NoteInput extends StatefulWidget {
  final VoidCallback selectHandler;
  final TextEditingController controller;
  NoteInput({
    Key? key,
    required this.selectHandler,
    required this.controller,
  }) : super(key: key);

  @override
  _NoteInputState createState() => _NoteInputState();
}

class _NoteInputState extends State<NoteInput> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: IconButton(
            icon: const Icon(
              Icons.image,
              color: Colors.blue,
            ),
            onPressed: () => setState(() {}),
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
            onPressed: widget.selectHandler,
          ),
        ),
      ],
    );
  }
}
