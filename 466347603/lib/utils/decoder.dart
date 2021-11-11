import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class Decoder {
  static Image imageFromBase64String(String base64String) {
    return Image.memory(
      base64Decode(base64String),
      fit: BoxFit.fill,
    );
  }

  static String base64String(Uint8List data) {
    return base64Encode(data);
  }

  Decoder._();
}
