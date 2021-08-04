import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants.dart';

class BottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(
          left: kDefaultPadding * 2,
          right: kDefaultPadding * 2,
          bottom: kDefaultPadding,
        ),
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              offset: Offset(0, -10),
              blurRadius: 35,
              color: kPrimaryColor.withOpacity(0.38),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              iconSize: 32,
              icon: Icon(Icons.home_rounded),
              color: kPrimaryColor,//SvgPicture.asset('assets/icons/home.svg'),
              onPressed: () {},
            ),
            IconButton(
                iconSize: 32,
                icon: SvgPicture.asset('assets/icons/clipboard.svg'),//Icon(Icons.date_range_outlined),
                color: kPrimaryColor,
                onPressed: () {}),
            IconButton(
                icon: SvgPicture.asset('assets/icons/clock.svg'),
                onPressed: () {}),
          ],
        ));
  }
}
