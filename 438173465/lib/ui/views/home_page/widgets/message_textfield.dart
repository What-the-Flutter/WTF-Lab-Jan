import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Container messageTextField({
  Function onPressedButton,
  ImagePicker picker,
  File image,
  TextEditingController controller,
}) {
  return Container(
    padding: EdgeInsets.only(
      left: 10,
      bottom: 10,
      top: 10,
    ),
    height: 60,
    width: double.infinity,
    child: Row(
      children: <Widget>[
        IconButton(
          icon: Icon(
            Icons.add,
            size: 30,
          ),
          onPressed: () {
            print('tap');
            getImage(
              picker: picker,
              image: image,
            );
          },
        ),
        SizedBox(
          width: 15,
        ),
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Write message...',
              border: InputBorder.none,
            ),
          ),
        ),
        SizedBox(
          width: 15,
        ),
        FloatingActionButton(
          onPressed: () => onPressedButton(),
          child: Icon(
            Icons.send,
            color: Colors.white,
            size: 18,
          ),
          backgroundColor: Colors.blue,
          elevation: 0,
        ),
      ],
    ),
  );
}

Future getImage({
  ImagePicker picker,
  File image,
}) async {
  final pickedFile = await picker.getImage(
    source: ImageSource.gallery,
  );
  if (pickedFile != null) {
    image = File(
      pickedFile.path,
    );
  } else {
    print('No image selected.');
  }
}
