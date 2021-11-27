import 'dart:io';

import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

class EventMessage extends StatelessWidget {
  final String? text;
  final String date;
  final int index;
  final File? imageFile;
  final bool isSelected;
  final void Function(int, bool) toggleAppBar;

  const EventMessage({
    Key? key,
    required this.date,
    required this.index,
    required this.toggleAppBar,
    required this.isSelected,
    this.text,
    this.imageFile,
  }) : super(key: key);

  bool get isTextEvent => (imageFile == null && text != null);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 5,
        bottom: 5,
        top: 5,
        right: 20,
      ),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: GestureDetector(
          onLongPress: _toggleSelection,
          onTap: () {
            if (isSelected) {
              _toggleSelection();
            }
          },
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: isSelected ? AppColors.blue400 : AppColors.blue200,
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  isTextEvent
                      ? Text(
                          text!,
                          style: const TextStyle(fontSize: 16),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              imageFile!,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                  Text(
                    date,
                    style: const TextStyle(color: AppColors.grey600),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _toggleSelection() => toggleAppBar(index, isSelected);
}
