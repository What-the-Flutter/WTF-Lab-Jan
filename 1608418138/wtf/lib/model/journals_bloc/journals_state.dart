part of 'journals_bloc.dart';

class JournalsState {
  List<Journal>? journals;
  var controller = TextEditingController();
  JournalsState({this.journals,});
  //JournalsState.initial(this.journals = ['Travel','Sports','Family'].forEach((name)=>Journal.empty(name))) ??
  JournalsState.initial() {
    journals = ['Travel', 'Sports', 'Family']
        .map((name) => Journal.empty(name))
        .toList();
  }


}
class JournalPageOpened extends JournalsState{
  final int journalInd;

  JournalPageOpened(this.journalInd,journals){
    super.journals=journals;
  }
}
class MessageSelected extends JournalPageOpened{
  final int messageInd;

  MessageSelected(this.messageInd,journalInd,journals):super(journalInd,journals);
}

class ChangingMessage extends MessageSelected{
  ChangingMessage(int messageInd, int journalInd,List<Journal>? journals):super(messageInd,journalInd,journals,){
    super.controller.text = journals![journalInd].messages[messageInd].text;
  }
}
