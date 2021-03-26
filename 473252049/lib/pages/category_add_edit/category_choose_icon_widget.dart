import 'package:flutter/material.dart';

class CategoryChooseIconWidget extends StatelessWidget {
  final IconData iconData;
  final Color backgroundColor;

  const CategoryChooseIconWidget({
    Key key,
    @required this.iconData,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor ?? Theme.of(context).backgroundColor,
          borderRadius: BorderRadius.all(
            Radius.circular(60),
          ),
        ),
        child: Icon(iconData),
      ),
    );
  }
}
