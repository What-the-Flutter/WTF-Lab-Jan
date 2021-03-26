import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<ImageSource> showChooseImageSourceDialog(BuildContext context) async {
  ImageSource imageSource;
  await showDialog(
    context: context,
    builder: (context) {
      return SimpleDialog(
        title: Text('Choose image source'),
        children: [
          SimpleDialogOption(
            onPressed: () {
              Navigator.of(context).pop();
              imageSource = ImageSource.camera;
            },
            child: Text('Camera'),
          ),
          SimpleDialogOption(
            onPressed: () {
              Navigator.of(context).pop();
              imageSource = ImageSource.gallery;
            },
            child: Text('Gallery'),
          ),
        ],
      );
    },
  );
  return imageSource;
}

Future<File> getImage(ImageSource imageSource) async {
  final picker = ImagePicker();
  final pickedImage = await picker.getImage(
    source: imageSource,
  );
  return pickedImage == null ? null : File(pickedImage.path);
}
