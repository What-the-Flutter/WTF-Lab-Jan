import 'package:flutter/material.dart';

class MainListElement extends StatelessWidget {
  final IconData icon;
  final String elementName;
  final String elementSubname;
  final SnackBar _snackBar = const SnackBar(
    content: Text('Long press'),
    duration: Duration(seconds: 1),
  );

  MainListElement({
    Key? key,
    required this.icon,
    required this.elementName,
    required this.elementSubname,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          child: ListTile(
            dense: false,
            leading: CircleAvatar(
              radius: 30,
              child: Center(
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 29,
                ),
              ),
              backgroundColor: const Color.fromRGBO(121, 143, 154, 1),
            ),
            title: Text(
              elementName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(elementSubname),
            onTap: () {},
          ),
          onLongPress: () {
            ScaffoldMessenger.of(context).showSnackBar(_snackBar);
          },
        ),
        const Divider(
          height: 18,
          thickness: 1,
        ),
      ],
    );
  }
}
