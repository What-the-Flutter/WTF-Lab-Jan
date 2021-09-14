import 'package:flutter/material.dart';


Color mainColor = const Color(0xFF173E47);
Color unselectedIconColor = const Color(0xFFE5E0EF);
Color eventBackgroundColor = const Color(0xFFFFFFFF);
Color markedMessageColor = const Color(0xFFD0E1E8);
Color eventIconColor = const Color(0xFFF0F4FA);
BoxDecoration backgroundDecoration = const BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFEFF7FA),
      Color(0xFFF7F1FC),
    ],
  ),
);
const double radiusValue = 10;
BorderRadius borderRadiusTop = const BorderRadius.vertical(
  top: Radius.circular(radiusValue),
);
BorderRadius borderRadius = const BorderRadius.all(Radius.circular(radiusValue));
BorderRadius borderRadiusBottom = const BorderRadius.vertical(
bottom: Radius.circular(radiusValue));