import 'package:flutter/material.dart';

import '../../../constants.dart';

class BotButton extends StatelessWidget {
  const BotButton({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: kDefaultPadding,
        right: kDefaultPadding,
        bottom: kDefaultPadding,
      ),
      margin: EdgeInsets.only(bottom: kDefaultPadding),
      width: size.width,
      height: size.height * 0.12,
      decoration: BoxDecoration(
          color: kPrimaryColor,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(36),
            bottomRight: Radius.circular(36),
          ),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 10),
              blurRadius: 50,
              color: kPrimaryColor.withOpacity(0.6),
            ),
          ]),
      child: Container(
        margin: EdgeInsets.only(top: kDefaultPadding * 1.5),
        child: ElevatedButton.icon(
          onPressed: () {},
          icon: Icon(
            Icons.chat_rounded,
            size: 24,
            color: Color(0xff87D2F7),
          ),
          label: Text(
            "Questionnaire Bot",
            style: TextStyle(
                color: kTextColor,
                fontSize: 16,
                fontWeight: FontWeight.w400,
                letterSpacing: 2),
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