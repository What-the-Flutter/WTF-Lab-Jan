import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import 'event_extras.dart';

class EventPageBloc extends Bloc<EventPageEvent, EventPageState> {
  final myController = TextEditingController();
  final picker = ImagePicker();
  EventPageBloc() : super(EventPageState(events: [],searchEvents: []));
  late bool insert = false;
  @override
  Stream<EventPageState> mapEventToState(EventPageEvent event) async*{
    if(event is EventImageEvent){
      state.image = event.image;
      yield state;
    }
    if(event is AddEventEvent){
      event.events.add(event.event);
      yield state.copyWith(events: event.events,icon:null);
    }
    if(event is EditEventEvent){
      event.events[event.index].text = event.text;
      yield state.copyWith(events: event.events);
    }
    if(event is DeleteEventEvent){
      event.events.remove(event.event);
      yield state.copyWith(events: event.events);
    }
    if(event is SearchEventEvent){
      event.searchEvents.add(event.event);
      yield state.copyWith(searchEvents: event.searchEvents);
    }
    if(event is AddIconEvent){
      yield state.copyWith(icon:event.icon);
    }
  }

}