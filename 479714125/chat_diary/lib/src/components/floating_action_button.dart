import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class AppFloatingActionButton extends StatelessWidget {
  final Function() onPressed;
  final Widget? child;
  const AppFloatingActionButton({Key? key, required this.onPressed, this.child})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: AppColors.sandPurple,
      foregroundColor: AppColors.black,
      splashColor: AppColors.darkSandPurple,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}
