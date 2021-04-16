import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../data/theme/custom_theme.dart';

class SearchItem extends StatelessWidget {
  final String name;
  final IconData iconData;
  final SearchItemTheme theme;
  final Function onTap;
  final bool isSelected;

  const SearchItem({
    Key key,
    this.name,
    this.iconData,
    this.theme,
    this.onTap,
    this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: BoxConstraints(
          minWidth: size.width * (3 / 10),
          minHeight: size.height * (5 / 100),
        ),
        padding: EdgeInsets.symmetric(horizontal: 5.0),
        alignment: AlignmentDirectional.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(theme.radius),
          color: theme.backgroundColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            if (isSelected) Icon(Icons.done),
            if (iconData != null) Icon(iconData),
            Text(
              name,
              style: theme.nameStyle,
            ),
          ],
        ),
      ),
    );
  }
}
