import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wtf/model/data_classes/message.dart';
import 'package:wtf/model/journals_bloc/journals_bloc.dart';
import 'package:wtf/UI/appbar.dart';
part 'input_field.dart';

part 'journal_messages.dart';

part 'message.dart';

class JournalPage extends StatelessWidget {
  final int journalInd;

  JournalPage(this.journalInd);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<JournalsBloc, JournalsState>(
      builder: (context, state) {
        return  Scaffold(
          appBar: JournalsAppBar(),
          body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(child: MessagesView(journalInd)),
                InputField(journalInd),
              ],
            ),
        );
      },
    );
  }
}
