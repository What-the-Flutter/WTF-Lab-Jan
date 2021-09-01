import 'package:flutter/material.dart';

import '../../../utils/utils.dart';
import 'bloc/bloc.dart';

class FontSizePickerDialog extends StatefulWidget {
  final double initialFontSizeIndex;
  final List<SettingsFontSize> values;

  const FontSizePickerDialog({
    Key? key,
    required this.initialFontSizeIndex,
    required this.values,
  }) : super(key: key);

  @override
  _FontSizePickerDialogState createState() => _FontSizePickerDialogState();
}

class _FontSizePickerDialogState extends State<FontSizePickerDialog> {
  late double _fontSizeIndex;

  @override
  void initState() {
    super.initState();
    _fontSizeIndex = widget.initialFontSizeIndex;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Font Size'),
      content: Wrap(children: [
        Column(
          children: [
            SizedBox(
              height: widget.values.last.toFontSize() * 2,
              child: Center(
                child: Text(
                  'Text example',
                  style: TextStyle(
                    fontSize: SettingsFontSize.values[_fontSizeIndex.toInt()].toFontSize(),
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Text('F', style: TextStyle(fontSize: widget.values.first.toFontSize())),
                Slider(
                  value: _fontSizeIndex,
                  min: 0,
                  max: widget.values.length - 1,
                  divisions: widget.values.length - 1,
                  onChanged: (value) => setState(() => _fontSizeIndex = value),
                ),
                Text('F', style: TextStyle(fontSize: widget.values.last.toFontSize())),
              ],
            ),
          ],
        ),
      ]),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('CANCEL')),
        TextButton(
          onPressed: () => Navigator.of(context).pop(
            SettingsFontSize.values[_fontSizeIndex.toInt()],
          ),
          child: const Text('OK'),
        ),
      ],
    );
  }
}
