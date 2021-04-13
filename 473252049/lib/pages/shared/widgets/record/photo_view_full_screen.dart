import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class PhotoViewFullScreen extends StatelessWidget {
  final List<File> images;

  const PhotoViewFullScreen({Key key, this.images}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: PhotoViewGallery.builder(
        itemCount: images.length,
        builder: (context, index) {
          return PhotoViewGalleryPageOptions(
            heroAttributes:
                PhotoViewHeroAttributes(tag: images[index].uri.toString()),
            imageProvider: Image.file(
              images[index],
              cacheHeight: 400,
            ).image,
            maxScale: PhotoViewComputedScale.covered * 2,
            minScale: PhotoViewComputedScale.contained,
          );
        },
        loadingBuilder: (context, progress) {
          return Center(
            child: CircularProgressIndicator(
              value: progress == null
                  ? null
                  : progress.cumulativeBytesLoaded /
                      progress.expectedTotalBytes,
            ),
          );
        },
      ),
    );
  }
}
