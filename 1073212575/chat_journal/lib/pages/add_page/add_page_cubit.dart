import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jiffy/jiffy.dart';

import '../../models/events.dart';
import '../home_page/home_page_screen.dart';
import 'add_page_state.dart';



class AddPageCubit extends Cubit<AddPageState> {
  AddPageCubit()
      : super(
          AddPageState(selectedIconIndex: 0),
        );

  void addPage(
    BuildContext context,
    TextEditingController controller,
    List iconsList,
  ) {
    eventPages.add(
      EventPages(
        controller.text,
        iconsList[state.selectedIconIndex],
        [],
        Jiffy(DateTime.now()).format('d/M/y h:mm a'),
      ),
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(),
      ),
    );
  }

  void edit(
    BuildContext context,
    int selectedPageIndex,
    TextEditingController controller,
    List iconsList,
  ) {
    final tempMessages = eventPages[selectedPageIndex].eventMessages;
    var tempDate = eventPages[selectedPageIndex].date;
    var tempName = controller.text;
    var tempIcon = iconsList[state.selectedIconIndex];
    var tempEventPages = EventPages(
      tempName,
      tempIcon,
      tempMessages,
      tempDate,
    );
    eventPages.removeAt(selectedPageIndex);
    eventPages.insert(
      selectedPageIndex,
      tempEventPages,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(),
      ),
    );
  }

  void setIconIndex(int i) {
    emit(
      state.copyWith(selectedIconIndex: i),
    );
  }

  void selectIcon(int i) {}
}
