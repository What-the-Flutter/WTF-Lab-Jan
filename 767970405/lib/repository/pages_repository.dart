import 'package:flutter/material.dart';
import 'messages_repository.dart';

import 'property_page.dart';

class PagesRepository {
  final List<PropertyPage> eventPages = <PropertyPage>[
    PropertyPage(
      icon: Icons.book_sharp,
      title: 'Journal',
      messages: MessagesRepository(),
      creationTime: DateTime.now(),
      lastModifiedTime: DateTime.now(),
      isPin: false,
    ),
    PropertyPage(
      icon: Icons.import_contacts_rounded,
      title: 'Notes',
      messages: MessagesRepository(),
      creationTime: DateTime.now(),
      lastModifiedTime: DateTime.now(),
      isPin: false,
    ),
    PropertyPage(
      icon: Icons.nature_people,
      title: 'Gratitude',
      messages: MessagesRepository(),
      creationTime: DateTime.now(),
      lastModifiedTime: DateTime.now(),
      isPin: false,
    )
  ];

  void addPage(PropertyPage page) {
    eventPages.add(page);
  }

  void editPage(int index, PropertyPage page) {
    eventPages[index] = page;
  }

  void removePage(int index) {
    eventPages.removeAt(index);
  }
}
