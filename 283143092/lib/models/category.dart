import 'package:flutter/cupertino.dart';

import 'package:intl/intl.dart';

class Category {
  final String name;
  final IconData icon;
  final bool favourite;
  final DateTime created;

  Category(this.name, this.icon, this.favourite, this.created);

  String get formattedDate => DateFormat('dd MMMM yyyy - H:m').format(created);

  int sort() => favourite ? 1 : -1;
}
