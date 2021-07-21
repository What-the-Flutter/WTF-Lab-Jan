import 'package:flutter/material.dart';
import 'package:personal_chat/constants.dart';

class MyItem extends StatelessWidget {
  final String title;
  final AssetImage img;
  const MyItem({Key key, this.title, this.img}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 30.0),
            decoration: BoxDecoration(
              color: Color(0xFFFFFEFB),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w900,
                fontFamily: 'SairaStencilOne-Regular',
                color: black,
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10),
          height: 100,
          decoration: BoxDecoration(
              color: Color(0xFFFEDB81).withOpacity(0.3),
              borderRadius: BorderRadius.circular(8)),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: blue, borderRadius: BorderRadius.circular(50)),
                margin: EdgeInsets.all(10.0),
                padding: EdgeInsets.all(10.0),
                child: Image(
                  image: img,
                  width: 50,
                  height: 50,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 13.0, right: 4.0),
                child: Text(
                  'No Events. Click to create one.',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w200),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
