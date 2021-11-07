import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

class EventMessage extends StatelessWidget {
  final String text;
  final String date;

  const EventMessage({
    Key? key,
    required this.text,
    required this.date,
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
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: AppColors.blue200,
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: const TextStyle(fontSize: 16),
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
    );
  }
}
