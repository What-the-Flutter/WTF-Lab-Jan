import 'package:flutter/material.dart';

class BouncyPageRoute extends PageRouteBuilder {
  final Widget widget;
  BouncyPageRoute({
    required this.widget,
  }) : super(
            transitionDuration: const Duration(seconds: 1),
            transitionsBuilder: (
              context,
              animation,
              secAnimation,
              child,
            ) {
              animation = CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOut,
              );
              return ScaleTransition(
                scale: animation,
                child: child,
                alignment: Alignment.center,
              );
            },
            pageBuilder: (
              context,
              animation,
              secAnimation,
            ) {
              return widget;
            });
}
