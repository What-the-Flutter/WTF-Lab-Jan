import 'package:flutter/material.dart';

import '../../model/category.dart';
import '../../views/category_view.dart';

final homePageContentStateKey = GlobalKey<_HomePageContentState>();

class HomePageContent extends StatefulWidget {
  final List<Category> categories;

  HomePageContent(this.categories, {Key key}) : super(key: key);

  @override
  _HomePageContentState createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: widget.categories.length + 1,
      separatorBuilder: (context, index) => Divider(),
      itemBuilder: (context, index) => index == 0
          ? _questionnaireBotButton(context)
          : CategoryView(widget.categories[index - 1]),
    );
  }
}

Widget _questionnaireBotButton(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
    child: TextButton(
      style: Theme.of(context).textButtonTheme.style,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Icon(
              Icons.chat,
              size: 28,
            ),
          ),
          Text(
            'Questionnaire Bot',
            style: Theme.of(context).textTheme.headline6,
          ),
        ],
      ),
      onPressed: () {},
    ),
  );
}
