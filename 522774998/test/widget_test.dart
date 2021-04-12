// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:try_bloc_app/main.dart';
import 'package:try_bloc_app/pages/search/searching_message.dart';

void main() {
  // Define a test. The TestWidgets function also provides a WidgetTester
  // to work with. The WidgetTester allows building and interacting
  // with widgets in the test environment.
  testWidgets('InputAppBar has a title', (WidgetTester tester) async {
    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(InputAppBar(title: 'T'));

    // Create the Finders.
    final titleFinder = find.text('T');

    // Use the `findsOneWidget` matcher provided by flutter_test to
    // verify that the Text widgets appear exactly once in the widget tree.
    expect(titleFinder, findsOneWidget);
  });
}

class InputAppBar extends StatefulWidget {
  final String title;

  const InputAppBar({Key key, this.title}) : super(key: key);

  @override
  _InputAppBarState createState() => _InputAppBarState();
}

class _InputAppBarState extends State<InputAppBar> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Center(
            child: Text(
              widget.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
            ),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(
                left: 10,
              ),
              child: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      SearchingPage.routeName,
                    );
                  }),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 10,
              ),
              child: IconButton(
                icon: Icon(
                  Icons.bookmark,
                  color: Colors.yellow,
                ),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
