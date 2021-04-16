import 'package:flutter/material.dart';

List<PopupMenuItem> popUpMenu() {
  return <PopupMenuItem>[
    PopupMenuItem(
      value: 1,
      child: const Text('Copy'),
    ),
    PopupMenuItem(
      value: 2,
      child: const Text('Delete'),
    ),
    PopupMenuItem(
      value: 3,
      child: const Text('Edit'),
    ),
  ];
}
