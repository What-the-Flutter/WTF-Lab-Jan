import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

class EventMessage extends StatefulWidget {
  final String text;
  final String date;
  final int index;
  final bool isSelected;
  final void Function(int, bool) toggleAppBar;

  const EventMessage({
    Key? key,
    required this.text,
    required this.date,
    required this.index,
    required this.toggleAppBar,
    required this.isSelected,
  }) : super(key: key);

  @override
  State<EventMessage> createState() => _EventMessageState();
}

class _EventMessageState extends State<EventMessage> {
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
          onLongPress: () => setState(_toggleSelection),
          onTap: () {
            if (widget.isSelected) {
              setState(_toggleSelection);
            }
          },
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: widget.isSelected ? AppColors.blue400 : AppColors.blue200,
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.text,
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    widget.date,
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
    widget.toggleAppBar(widget.index, widget.isSelected);
  }
}
