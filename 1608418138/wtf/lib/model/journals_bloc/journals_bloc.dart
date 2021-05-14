import 'dart:async';
import 'package:wtf/model/data_classes/journal.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wtf/model/data_classes/message.dart';
import 'package:flutter/material.dart';
part 'journals_event.dart';
part 'journals_state.dart';

class JournalsBloc extends Bloc<JournalsEvent, JournalsState> {
  JournalsBloc() : super(JournalsState.initial());

  @override
  Stream<JournalsState> mapEventToState(
    JournalsEvent event,
  ) async* {
    JournalsState journalsState = state;
    if(event is SendPressed){
      if(journalsState is ChangingMessage){
        journalsState.journals![event.journalInd].messages[journalsState.messageInd] = Message(text:journalsState.controller.value.text);
        journalsState.controller.clear();
        yield JournalPageOpened(event.journalInd, journalsState.journals);
      }
      else{
        var journals = state.journals;
        journals![event.journalInd].messages.add(Message(text:journalsState.controller.value.text));
        state.controller.clear();
        yield JournalPageOpened(event.journalInd, journals);
      }
    }
    else if(event is SelectMessage){
      if(journalsState is MessageSelected == false){
        yield MessageSelected(event.messageInd,event.journalInd,state.journals);
      }
    }
    else if(event is RemoveMessage){
      if(journalsState is MessageSelected){
        var journals = state.journals;
        journals![event.journalInd].messages.removeAt(event.messageInd);
        yield JournalPageOpened(event.journalInd, journals);
      }
      else{
        //err
      }
    }
    else if(event is BackToJournal){
      if(journalsState is MessageSelected){
        yield JournalPageOpened(event.journalInd, state.journals);
      }
    }
    else if(event is SelectJournal){
      yield JournalPageOpened(event.journalInd,state.journals);
    }
    else if(event is ChangeMessage){
      yield ChangingMessage(event.messageInd, event.journalInd, state.journals);
    }
    else if(event is ToggleFavourites){
      var journals = state.journals;
      journals![event.journalInd].messages[event.messageInd].selected=(journals[event.journalInd].messages[event.messageInd].selected!=true);
      yield JournalPageOpened(event.journalInd, journals);
    }
  }
}
