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
