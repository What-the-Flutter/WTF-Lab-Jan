import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../pages/settings/settings.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      title: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: SvgPicture.asset(
          'assets/img/Frame 11.svg',
          alignment: Alignment.bottomCenter,
        ),
      ),
      leading: Padding(
        padding: const EdgeInsets.only(left: 20.0),
        child: IconButton(
          icon: SvgPicture.asset('assets/img/Hamburger.svg'),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Settings()),
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: IconButton(
            icon: Image.asset('assets/img/Ellipse 2.png'),
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(60);
}
