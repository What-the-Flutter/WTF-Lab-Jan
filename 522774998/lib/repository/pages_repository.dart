import 'package:flutter/material.dart';
import '../database/database.dart';
import 'messages_repository.dart';

import 'property_page.dart';

class PagesRepository {
  final DBHelper _dbHelper = DBHelper();
  List<PropertyPage> dialogPages;

  void setAllPages() async {
    var dbPageList = await _dbHelper.dbPagesList();
    dialogPages = dbPageList;
  }

  void addPage(PropertyPage page) {
    dialogPages.add(page);
  }

  void editPage(int index, PropertyPage page) {
    dialogPages[index] = page;
  }

  void removePage(int index) {
    dialogPages.removeAt(index);
  }
}

final List<PropertyPage> dialogPages = <PropertyPage>[
  PropertyPage(
    icon: Icons.book_sharp,
    title: 'Journal',
    messages: MessagesRepository(),
    creationTime: DateTime.now(),
    lastModifiedTime: DateTime.now(),
    isPin: false,
    id: 1,
  ),
  PropertyPage(
    icon: Icons.import_contacts_rounded,
    title: 'Notes',
    messages: MessagesRepository(),
    creationTime: DateTime.now(),
    lastModifiedTime: DateTime.now(),
    isPin: false,
    id: 2,
  ),
  PropertyPage(
    icon: Icons.nature_people,
    title: 'Gratitude',
    messages: MessagesRepository(),
    creationTime: DateTime.now(),
    lastModifiedTime: DateTime.now(),
    isPin: false,
    id: 3,
  )
];
