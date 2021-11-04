import 'package:flutter/material.dart';

class SimilarScreenTop extends StatelessWidget with PreferredSizeWidget {
  SimilarScreenTop({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.indigo,
      title: const Align(
        child: Text('HOME'),
        alignment: Alignment.center,
      ),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
            right: 20.0,
          ),
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
