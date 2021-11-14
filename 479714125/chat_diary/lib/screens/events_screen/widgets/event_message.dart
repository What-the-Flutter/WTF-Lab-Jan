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
                  (imageFile == null && text != null)
                      ? Text(
                          text!,
                          style: const TextStyle(fontSize: 16),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Image.file(
                            imageFile!,
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 2,
                            fit: BoxFit
                                .scaleDown, //maybe another or change padding for image
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

  void _toggleSelection() {
    toggleAppBar(index, isSelected);
  }
}
