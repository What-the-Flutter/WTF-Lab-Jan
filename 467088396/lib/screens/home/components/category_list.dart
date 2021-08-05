import 'package:flutter/material.dart';

import '../../../constants.dart';


class CategoryList extends StatelessWidget {
  const CategoryList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        children: <Widget>[
          CategoryCard(
            name: 'Travel',
            iconData: Icons.flight_takeoff_rounded,
            description: 'No events. Click to create one.',
          ),
          CategoryCard(
            name: 'Family',
            iconData: Icons.family_restroom_rounded,
            description: 'No events. Click to create one.',
          ),
          CategoryCard(
            name: 'Sports',
            iconData: Icons.sports_tennis_rounded,
            description: 'No events. Click to create one.',
          )
        ],
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    Key? key,
    required this.name,
    required this.description,
    required this.iconData,
  }) : super(key: key);

  final String name;
  final String description;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric( horizontal: kDefaultPadding,
          vertical: kDefaultPadding / 2),
      padding: EdgeInsets.all(kDefaultPadding / 2),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              spreadRadius: 5,
              blurRadius: 5,
              offset: Offset(3, 5),
              color: kPrimaryColor.withOpacity(0.10),
            ),
          ]),
      child: ListTile(
        title: Text(
          name,
          style: TextStyle(
              color: kTextColor,
              fontSize: 16,
              fontWeight: FontWeight.w400,
              letterSpacing: 1),
        ),
        subtitle: Text(description),
        leading: Icon(
          iconData,
          color: Color(0xff87D2F7),
          size: 32,
        ),
      ),
    );
  }
}