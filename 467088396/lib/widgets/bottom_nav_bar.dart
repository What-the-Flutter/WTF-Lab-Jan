import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants.dart';

class BottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: defaultPadding * 2,
        right: defaultPadding * 2,
        bottom: defaultPadding,
      ),
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
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
            color: primaryColor, //SvgPicture.asset('assets/icons/home.svg'),
            onPressed: () {},
          ),
          IconButton(
              iconSize: 32,
              icon: SvgPicture.asset(
                  'assets/icons/clipboard.svg'), //Icon(Icons.date_range_outlined),
              color: primaryColor,
              onPressed: () {}),
          IconButton(
              icon: SvgPicture.asset('assets/icons/clock.svg'),
              onPressed: () {}),
        ],
      ),
    );
  }
}
