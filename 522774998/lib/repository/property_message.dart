import 'package:flutter/material.dart';

class PropertyMessage {
  final bool isSelected;
  final IconData icon;
  String message;

  PropertyMessage(
      {@required this.message,
      this.isSelected = false,
      this.icon});

  PropertyMessage copyWith({
    String message,
    final bool isSelected,
    final IconData icon,
  }) {
    return PropertyMessage(
      message: message ?? this.message,
      isSelected: isSelected ?? this.isSelected,
      icon: icon ?? this.icon,
    );
  }
}
