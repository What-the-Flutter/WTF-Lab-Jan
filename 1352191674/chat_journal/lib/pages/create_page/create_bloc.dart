import 'package:chat_journal/pages/create_page/create_extras.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateBloc extends Bloc<CreateEvent, CreateState> {
  final controller = TextEditingController();

  CreateBloc() : super(CreateState(currentIconIndex:0));
  @override
  Stream<CreateState> mapEventToState(CreateEvent event) async*{
    if(event is NewIconEvent){
      yield state.copyWith(currentIconIndex:event.iconIndex);
    }
  }

}