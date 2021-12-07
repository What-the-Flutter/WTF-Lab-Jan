import 'package:flutter/material.dart';

class Category {
  final String title;
  final IconData icon;

  const Category({
    this.icon = Icons.favorite,
    this.title ='',
  });
}