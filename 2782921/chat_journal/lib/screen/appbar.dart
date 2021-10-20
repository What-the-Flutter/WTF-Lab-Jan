import 'package:flutter/material.dart';

class SimilarScreenTop extends StatefulWidget with PreferredSizeWidget {
  SimilarScreenTop({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _SimilarScreenTopState createState() => _SimilarScreenTopState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _SimilarScreenTopState extends State<SimilarScreenTop> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.indigo,
      title: Align(
        child: Text(widget.title),
        alignment: Alignment.center,
      ),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: GestureDetector(
            onTap: () {},
            child: const Icon(
              Icons.nightlight_round,
              size: 24.0,
            ),
          ),
        ),
      ],
    );
  }
}
