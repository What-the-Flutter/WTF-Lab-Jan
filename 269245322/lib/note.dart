import 'package:flutter/material.dart';

class ListObject extends StatelessWidget {
  final String heading;
  final String data;
  final String avatarUrl;
  final String ptiority;
  bool isFavorite = false;

  final Map<String, Color> nodePropertyColor = {
    'high': Colors.red,
    'medium': Colors.orange,
    'low': Colors.yellow,
  };

  ListObject({
    required this.heading,
    required this.data,
    required this.avatarUrl,
    required this.ptiority,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: ValueKey(heading),
      leading: Icon(
        Icons.alarm,
        color: nodePropertyColor[ptiority],
      ),
      title: Text('Node $heading'),
      subtitle: Text(data),
      isThreeLine: true,
    );
  }
}
