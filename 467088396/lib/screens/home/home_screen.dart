import 'package:chat_diary/components/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../constants.dart';

import 'components/body.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(),
        body: Body(),
        floatingActionButton: buildFloatingActionButton(),
        bottomNavigationBar: BottomNavBar());
  }

  FloatingActionButton buildFloatingActionButton() {
    return FloatingActionButton(
          onPressed: () {},
          elevation: 0,
          child: Container(
            padding: EdgeInsets.all(kDefaultPadding / 2),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(100),
                ),
                boxShadow: [
                  BoxShadow(
                    spreadRadius: 5,
                    blurRadius: 5,
                    offset: Offset(3, 5),
                    color: kPrimaryColor.withOpacity(0.20),
                  ),
                ],
              ),
              child: const Icon(Icons.add, color: Color(0xff87D2F7), size: 32)),
          backgroundColor: Colors.white);
  }

  AppBar buildAppBar() {
    return AppBar(
      elevation: 0,
      leading: IconButton(
        icon: SvgPicture.asset("assets/icons/menu.svg"),
        onPressed: () {},
      ),
      title: Text(
        "Diary",
        style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w300,
            letterSpacing: 6,
            fontSize: 26),
      ),
      actions: [
        IconButton(
            onPressed: () {},
            //iconSize: 28,
            icon: Icon(Icons.nightlight),
            color: Colors.white),
      ],
    );
  }
}
