import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../screens/events_screen.dart';

class MyItem extends StatefulWidget {
  final String title;
  final IconData icon;

  const MyItem({
    Key key,
    this.title,
    this.icon,
  }) : super(key: key);

  @override
  _MyItemState createState() => _MyItemState();
}

class _MyItemState extends State<MyItem> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            padding:
                const EdgeInsets.symmetric(vertical: 5.0, horizontal: 30.0),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFEFB).withOpacity(0.7),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              widget.title,
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w900,
                fontFamily: 'SairaStencilOne-Regular',
                color: black,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EventScreen(
                    appBarTitle: widget.title,
                  ),
                ),
              );
            });
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10),
            height: 100,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColorLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).accentColor,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  margin: const EdgeInsets.all(10.0),
                  padding: const EdgeInsets.all(10.0),
                  child: Icon(
                    widget.icon,
                    size: 50.0,
                    color: black,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 13.0, right: 4.0),
                  child: Text(
                    'No Events. Click to create one.',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w200),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
