import 'package:flutter/material.dart';

import '../constants.dart';

class BottomNavBar extends StatelessWidget {

  const BottomNavBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: defaultPadding * 2,
        right: defaultPadding * 2,
        //bottom: defaultPadding,
      ),
      height: 60,
      decoration: BoxDecoration(
        color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -10),
            blurRadius: 35,
            color: primaryColor.withOpacity(0.38),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            iconSize: 32,
            icon: const Icon(Icons.home_rounded),
            color: Theme.of(context)
                .bottomNavigationBarTheme
                .selectedItemColor, //SvgPicture.asset('assets/icons/home.svg'),
            onPressed: () {},
          ),
          IconButton(
              iconSize: 28,
              icon: const Icon(Icons.event_note_rounded),
              color: Theme.of(context)
                  .bottomNavigationBarTheme
                  .unselectedItemColor,
              onPressed: () {}),
          IconButton(
              iconSize: 28,
              icon: const Icon(Icons.access_time_rounded),
              color: Theme.of(context)
                  .bottomNavigationBarTheme
                  .unselectedItemColor,
              onPressed: () {}),
        ],
      ),
    );
  }
}
