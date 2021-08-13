import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../constants.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/home_body.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _appBar(),
        body: Body(),
        floatingActionButton: _floatingActionButton(),
        bottomNavigationBar: BottomNavBar());
  }

  FloatingActionButton _floatingActionButton() {
    return FloatingActionButton(
      onPressed: () {},
      elevation: 0,
      child: Container(
        padding: const EdgeInsets.all(defaultPadding / 2),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(
            Radius.circular(100),
          ),
          boxShadow: [
            BoxShadow(
              spreadRadius: 5,
              blurRadius: 5,
              offset: const Offset(3, 5),
              color: primaryColor.withOpacity(0.20),
            ),
          ],
        ),
        child: const Icon(Icons.add, color: Color(0xff87D2F7), size: 32),
      ),
      backgroundColor: Colors.white,
    );
  }

  AppBar _appBar() {
    return AppBar(
      elevation: 0,
      leading: IconButton(
        icon: SvgPicture.asset('assets/icons/menu.svg'),
        onPressed: () {},
      ),
      title: const Text(
        'Diary',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w300,
          letterSpacing: 6,
          fontSize: 26,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          //iconSize: 28,
          icon: const Icon(Icons.nightlight),
          color: Colors.white,
        ),
      ],
    );
  }
}
