import 'package:flutter/material.dart';

import '../../model/category.dart';
import '../../views/category_view.dart';

class HomePageContent extends StatelessWidget {
  final List<Category> _categories;

  HomePageContent(this._categories);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: _categories.length + 1,
      separatorBuilder: (context, index) => Divider(),
      itemBuilder: (context, index) => index == 0
          ? _questionnaireBot(context)
          : CategoryView(_categories[index - 1]),
    );
  }
}

Widget _questionnaireBot(BuildContext context) {
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
