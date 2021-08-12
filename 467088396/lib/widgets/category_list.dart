import 'package:flutter/material.dart';

import '../constants.dart';
import '../screens/event_page.dart';

class CategoryList extends StatelessWidget {

  CategoryList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        children: <Widget>[
          CategoryCard(
            name: 'Travel',
            iconData: Icons.flight_takeoff_rounded,
            description: //eventMap['Travel']!.isNotEmpty
                //? eventMap['Travel']!.last :
                 'No events. Click to create one.',
          ),
          CategoryCard(
            name: 'Family',
            iconData: Icons.family_restroom_rounded,
            description: //eventMap['Family']!.isNotEmpty
                //? eventMap['Family']!.last :
                 'No events. Click to create one.',
          ),
          CategoryCard(
            name: 'Sports',
            iconData: Icons.sports_tennis_rounded,
            description: //eventMap['Sports']!.isNotEmpty
                //? eventMap['Sports']!.last :
                 'No events. Click to create one.',
          )
        ],
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String name;
  final String description;
  final IconData iconData;

  CategoryCard({
    Key? key,
    required this.name,
    required this.description,
    required this.iconData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EventPage(title: name)),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(
            horizontal: defaultPadding, vertical: defaultPadding / 2),
        padding: const EdgeInsets.all(defaultPadding / 2),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              spreadRadius: 5,
              blurRadius: 5,
              offset: const Offset(3, 5),
              color: primaryColor.withOpacity(0.10),
            ),
          ],
        ),
        child: ListTile(
          title: Text(
            name,
            style: const TextStyle(
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.w400,
                letterSpacing: 1),
          ),
          subtitle: Text(description),
          leading: Icon(
            iconData,
            color: const Color(0xff87D2F7),
            size: 32,
          ),
        ),
      ),
    );
  }
}
