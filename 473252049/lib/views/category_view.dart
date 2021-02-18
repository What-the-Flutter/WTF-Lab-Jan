import 'package:chat_journal/pages/category_chat_page.dart';
import 'package:chat_journal/views/category_bottom_sheet_view.dart';
import 'package:flutter/material.dart';
import '../model/category.dart';

class CategoryView extends StatelessWidget {
  final Category _category;

  const CategoryView(this._category);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => CategoryChatPage(
                  _category,
                  key: categoryChatPageKey,
                )));
      },
      onLongPress: () => showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return CategoryBottomSheetView(_category);
          }),
      child: Container(
        constraints: BoxConstraints(
          minHeight: 80,
        ),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: AspectRatio(
                child: Icon(
                  _category.icon,
                  size: 36,
                ),
                aspectRatio: 1,
              ),
            ),
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_category.name,
                      style: Theme.of(context).textTheme.headline5),
                  Text(
                    _category.records.isEmpty
                        ? 'No events. Tap to create first'
                        : _category.records.first.message,
                    style: Theme.of(context).textTheme.bodyText1,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Expanded(
                flex: 2,
                child: Text(
                  'Yesterday',
                  style: Theme.of(context).textTheme.bodyText2,
                  textAlign: TextAlign.center,
                )),
          ],
        ),
      ),
    );
  }
}
