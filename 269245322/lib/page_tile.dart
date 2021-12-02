import 'package:flutter/material.dart';
import 'objects/page_object.dart';

class PageTile extends StatelessWidget {
  late final PageObject page;

  Key get pageKey => page.pageKey;

  PageTile({
    required title,
    required icon,
  }) {
    page = PageObject(title: title, icon: icon);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: ValueKey(page.title),
      leading: Icon(page.icon),
      title: Text('${page.title} page'),
      subtitle: Text(page.notesList[page.numOfNotes].data),
    );
  }
}
