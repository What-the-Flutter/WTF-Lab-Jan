import 'package:flutter/material.dart';
import '../model/model_page.dart';
import 'messages_repository.dart';



class PagesRepository {
  final List<ModelPage> eventPages = <ModelPage>[
    ModelPage(
      icon: Icons.book_sharp,
      title: 'Journal',
      messages: MessagesRepository(),
      creationTime: DateTime.now(),
      lastModifiedTime: DateTime.now(),
      isPin: false,
    ),
    ModelPage(
      icon: Icons.import_contacts_rounded,
      title: 'Notes',
      messages: MessagesRepository(),
      creationTime: DateTime.now(),
      lastModifiedTime: DateTime.now(),
      isPin: false,
    ),
    ModelPage(
      icon: Icons.nature_people,
      title: 'Gratitude',
      messages: MessagesRepository(),
      creationTime: DateTime.now(),
      lastModifiedTime: DateTime.now(),
      isPin: false,
    )
  ];

  void addPage(ModelPage page) {
    eventPages.add(page);
  }

  void editPage(int index, ModelPage page) {
    eventPages[index] = page;
  }

  void removePage(int index) {
    eventPages.removeAt(index);
  }
}
