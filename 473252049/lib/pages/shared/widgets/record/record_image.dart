import 'dart:io';

import 'package:flutter/material.dart';

import 'photo_view_full_screen.dart';

class RecordImage extends StatelessWidget {
  final File image;

  const RecordImage({Key key, @required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Container(
        constraints: BoxConstraints(
          maxHeight: 400,
          minWidth: constraints.maxWidth,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(4),
            bottomLeft: Radius.circular(2),
            bottomRight: Radius.circular(2),
          ),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return PhotoViewFullScreen(
                      images: [image],
                    );
                  },
                ),
              );
            },
            child: Hero(
              tag: image.uri.toString(),
              child: Image.file(
                image,
                cacheHeight: 400,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
