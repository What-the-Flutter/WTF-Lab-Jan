import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ChatBotListElement extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          child: Align(
            alignment: Alignment.center,
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromRGBO(228, 242, 227, 1),
                borderRadius: BorderRadius.circular(10),
              ),
              height: 50,
              width: 365,
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                  ),
                  const Icon(FontAwesomeIcons.robot),
                  const SizedBox(width: 28),
                  const Text(
                    'Questionnaire Bot',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
          onTap: () {},
        ),
        const Divider(
          height: 18,
          thickness: 1,
        ),
      ],
    );
  }
}

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
