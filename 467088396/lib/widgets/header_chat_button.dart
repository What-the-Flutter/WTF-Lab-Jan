import 'package:flutter/material.dart';

import '../constants.dart';

class BotButton extends StatelessWidget {
  final Size size;

  const BotButton({
    Key? key,
    required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: defaultPadding,
        right: defaultPadding,
        bottom: defaultPadding,
      ),
      margin: const EdgeInsets.only(bottom: defaultPadding),
      width: size.width,
      height: size.height * 0.12,
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(36),
          bottomRight: Radius.circular(36),
        ),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 10),
            blurRadius: 50,
            color: primaryColor.withOpacity(0.6),
          ),
        ],
      ),
      child: Container(
        margin: const EdgeInsets.only(top: defaultPadding * 1.5),
        child: ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(
            Icons.chat_rounded,
            size: 24,
            color: Color(0xff87D2F7),
          ),
          label: const Text(
            'Questionnaire Bot',
            style: TextStyle(
              color: textColor,
              fontSize: 16,
              fontWeight: FontWeight.w400,
              letterSpacing: 2,
            ),
          ),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0))),
          ),
        ),
      ),
    );
  }
}
