part of 'journals_bloc.dart';

@immutable
abstract class JournalsEvent {}

class AddMessage extends JournalsEvent{
  final int journalInd;
  final Message message;
  AddMessage(this.journalInd,this.message);
}

class RemoveMessage extends JournalsEvent{
  final int journalInd;
  final int messageInd;
  RemoveMessage(this.journalInd,this.messageInd);
}

class ChangeMessage extends JournalsEvent{
  final int journalInd;
  final int messageInd;
  ChangeMessage(this.journalInd,this.messageInd);
}

class ToggleFavourites extends JournalsEvent{
  final int journalInd;
  final int messageInd;
  ToggleFavourites(this.journalInd,this.messageInd);
}


class SelectJournal extends JournalsEvent{
  final int journalInd;
  SelectJournal(this.journalInd);
}

class SelectMessage extends JournalsEvent{
  final int journalInd;
  final int messageInd;
  SelectMessage(this.journalInd,this.messageInd);
}

class BackToJournal extends JournalsEvent{
  final int journalInd;
  final int messageInd;
  BackToJournal(this.journalInd, this.messageInd);
}
class BackToMainPage extends JournalsEvent{
  final int journalInd;
  final int messageInd;
  BackToMainPage(this.journalInd, this.messageInd);
}


class SendPressed extends JournalsEvent{
  final int journalInd;

  SendPressed(this.journalInd);
}