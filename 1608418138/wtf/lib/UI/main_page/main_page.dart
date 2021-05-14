import 'package:flutter/material.dart';
import 'package:wtf/UI/appbar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wtf/model/journals_bloc/journals_bloc.dart';
import 'bot_button.dart';
import 'bottom_bar.dart';
import 'package:wtf/UI/journal_page/journal_page.dart';
class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    JournalsBloc journalsBloc = BlocProvider.of<JournalsBloc>(context);
    Widget listItem(IconData icon, String title,
        {String substitle = "No events. Click Here to create one."}) {
      return ListTile(
        leading: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).unselectedWidgetColor,
          ),
          child: Icon(icon),
        ),
        title: Text(title),
        subtitle: Text(substitle),
      );
    }

    return BlocBuilder<JournalsBloc, JournalsState>(
      bloc: journalsBloc,
      builder: (context, state) {
        if (state is JournalPageOpened) {
          return JournalPage(state.journalInd);
        } else {
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.note_add_outlined),
              onPressed: () => {},
            ),
            appBar: JournalsAppBar(),
            body: ListView(
              children: [
                BotButton(),
                Divider(),
                GestureDetector(onTap:(){journalsBloc.add(SelectJournal(0));},child: listItem(Icons.accessibility_new_rounded, "Travel")),
                Divider(),
                listItem(Icons.accessibility_new_rounded, 'Family'),
                Divider(),
                listItem(Icons.accessibility_new_rounded, 'Sports'),
                Divider(),
              ],
            ),
            bottomNavigationBar: JournalBottomBar(),
          );
        }
      },
    );
  }
}
