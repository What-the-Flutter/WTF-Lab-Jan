import 'package:flutter/material.dart';
import 'pages/entity/list_item.dart';
import 'pages/home_page/home_page.dart';

final List<Category> categories = [
  Category('Travel', _titleForBlankScreen, Icons.airport_shuttle_sharp, []),
  Category('Family', _titleForBlankScreen, Icons.family_restroom_sharp, []),
  Category('Sports', _titleForBlankScreen, Icons.directions_bike, []),
];

void main() => runApp(
      MaterialApp(
        home: ChatJournal(),
      ),
    );

final String _titleForBlankScreen = 'No events. Click to create one';

class ChatJournal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChatJournal',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blueGrey,
        ),
      ),
      routes: {
        '/home_page': (context) => ChatJournalHomePage(
              categories: categories,
            ),
      },
      initialRoute: '/home_page',
    );
  }
}
