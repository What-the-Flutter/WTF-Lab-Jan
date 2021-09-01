

import 'package:chat_journal/models/page_mode.dart';
import 'package:chat_journal/pages/events_page/events_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'home_extras.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  static List<AppPage> list= [
  AppPage('Journal', Icons.book,EventPage(title:'Journal')),
  AppPage('Notes', Icons.import_contacts_outlined,EventPage(title:'Notes')),
  AppPage('Gratitude', Icons.nature_people_outlined,EventPage(title:'Gratitude'))
  ];
  static bool isLigth = true;

  HomeBloc() : super(HomeState(pages:list,isLigth:isLigth ));
  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async*{
    if(event is ThemeChangeEvent){
      isLigth = !isLigth;
      yield state.copyWith(isLigth:event.isLigth);
    };
    if(event is AddPageEvent){
      event.pages.add(event.page);
      print(state.pages.length.toString());
      yield state.copyWith(pages:event.pages);
    };
    if(event is EditPageEvent){
      event.pages[event.index] = event.page;
      yield state.copyWith(pages:event.pages);
    }
    if(event is DeletePageEvent){
      event.pages.removeAt(event.index);
      yield state.copyWith(pages:event.pages);
    }
  }
}