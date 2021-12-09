import 'package:flutter/material.dart';
import 'objects/note_object.dart';

class NoteTile extends StatelessWidget {
  late final NoteObject node;

  NoteTile({
    required heading,
    required data,
  }) {
    node = NoteObject(heading: heading, data: data);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: ValueKey(node.heading),
      leading: const Icon(Icons.alarm),
      title: Text('Node ${node.heading}'),
      subtitle: Text(node.data),
      isThreeLine: true,
    );
  }
}
