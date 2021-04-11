import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../data/theme/custom_theme.dart';

class Tag extends StatelessWidget {
  final String name;
  final TagTheme theme;
  final Function onTap;
  final bool isSelected;

  const Tag({
    Key key,
    this.name,
    this.theme,
    this.onTap,
    this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
