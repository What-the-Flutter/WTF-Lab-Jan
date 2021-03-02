import 'package:flutter/material.dart';

class PropertyMessage {
  final bool isFavor;
  final bool isSelected;
  final String message;

  PropertyMessage(
      {@required this.message, this.isFavor = false, this.isSelected = false});

  PropertyMessage copyWith({
    final String message,
    final bool isFavor,
    final bool isSelected,
  }) {
    return PropertyMessage(
      message: message ?? this.message,
      isFavor: isFavor ?? this.isFavor,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
