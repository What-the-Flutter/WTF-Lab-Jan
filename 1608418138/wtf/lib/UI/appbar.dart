import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wtf/model/journals_bloc/journals_bloc.dart';
import 'package:flutter/services.dart';
class JournalsAppBar extends StatelessWidget implements PreferredSizeWidget {
  JournalsAppBar() : preferredSize = Size.fromHeight(kToolbarHeight);

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    JournalsBloc journalsBloc = BlocProvider.of<JournalsBloc>(context);

    return BlocBuilder<JournalsBloc, JournalsState>(
      bloc: journalsBloc,
      builder: (context, state) {
        if (state is MessageSelected) {
          return AppBar(
            iconTheme: IconThemeData(color: Colors.black),
            actionsIconTheme: IconThemeData(color: Colors.black),
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: Icon(Icons.arrow_back,),
              onPressed: () {
                journalsBloc
                    .add(BackToJournal(state.journalInd, state.messageInd));
              },
            ),
            actions: [
              IconButton(
                color: Colors.black,
                icon:Icon(Icons.delete_outlined),
                onPressed: (){journalsBloc.add(RemoveMessage(state.journalInd, state.messageInd));},
              ),
              IconButton(
                icon:Icon(Icons.edit_outlined),
                onPressed: (){journalsBloc.add(ChangeMessage(state.journalInd, state.messageInd));},
              ),
              IconButton(
                icon:Icon(Icons.copy_outlined),
                onPressed: (){
                  Clipboard.setData(ClipboardData(text: state.journals![state.journalInd].messages[state.messageInd].text));
                  journalsBloc
                    .add(BackToJournal(state.journalInd, state.messageInd));},
              ),
              IconButton(
                icon:Icon(Icons.bookmark_border_outlined),
                onPressed: (){journalsBloc.add(ToggleFavourites(state.journalInd, state.messageInd));},
              ),
            ],
          );
        } else if (state is JournalPageOpened) {
          return AppBar(
            centerTitle: true,
            leading: Icon(Icons.menu_outlined),
            title: Text(state.journals![state.journalInd].name),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: Icon(Icons.invert_colors_on_outlined),
              ),
            ],
          );
        } else {
          return AppBar(
            centerTitle: true,
            leading: Icon(Icons.menu_outlined),
            title: Text('Home'),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: Icon(Icons.invert_colors_on_outlined),
              ),
            ],
          );
        }
      },
    );
  }
}
