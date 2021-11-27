import 'package:flutter/material.dart';

class BottomSheetCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final void Function() action;

  const BottomSheetCard({
    Key? key,
    required this.title,
    required this.icon,
    required this.color,
    required this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: action,
      child: SizedBox(
        height: 50,
        child: Row(
          children: [
            const SizedBox(width: 20),
            Icon(
              icon,
              color: color,
            ),
            const SizedBox(width: 30),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
