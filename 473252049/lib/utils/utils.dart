import 'package:flutter/services.dart';

void copyToClipboard(List<Object> list) {
  var buffer = StringBuffer();
  buffer.writeAll(list, '\n');
  Clipboard.setData(ClipboardData(text: buffer.toString()));
}
