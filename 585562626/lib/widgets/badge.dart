import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../utils/constants.dart';

class Badge extends StatelessWidget {
  final double top;
  final double right;
  final Widget child;
  final bool visible;
  late final Color color;

  Badge({required this.child, required this.top, required this.right, required this.visible});

  @override
  Widget build(BuildContext context) {
    color = Theme.of(context).accentColor;
    return Stack(
      alignment: Alignment.center,
      children: [
        child,
        if (visible)
          Positioned(
            right: right,
            top: top,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(CornerRadius.circle),
                color: color,
              ),
              constraints: const BoxConstraints(minWidth: 12, minHeight: 12),
            ),
          )
      ],
    );
  }
}
