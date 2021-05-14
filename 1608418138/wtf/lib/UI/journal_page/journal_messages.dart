part of 'journal_page.dart';

class MessagesView extends StatelessWidget {
  final int journalInd;

  const MessagesView(this.journalInd);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    JournalsBloc journalsBloc = BlocProvider.of<JournalsBloc>(context);
    return BlocBuilder<JournalsBloc, JournalsState>(
      bloc: journalsBloc,
      builder: (context, state) {
        print('Journal messages');
        return Container(
          width: size.width,
          child: ListView.builder(
            reverse: true,
            itemCount: state.journals![journalInd].messages.length,
            itemBuilder: (BuildContext context, int ind) {
              final len = state.journals![journalInd].messages.length;
              final reversedIndex = len - ind - 1;
              final unwrapedMessage = MessageView(
                state.journals![journalInd].messages[reversedIndex],
                () {
                  journalsBloc.add(SelectMessage(journalInd, reversedIndex));
                },
                () {
                  journalsBloc.add(ToggleFavourites(journalInd, reversedIndex));
                },
              );
              if (state is MessageSelected) {
                if (reversedIndex == state.messageInd) {
                  return Container(
                    color: Theme.of(context).accentColor,
                    child: unwrapedMessage,
                  );
                }
              }
              return unwrapedMessage;
            },
          ),
        );
      },
    );
  }
}
