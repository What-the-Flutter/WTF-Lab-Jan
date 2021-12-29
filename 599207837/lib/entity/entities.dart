import 'package:intl/intl.dart';

import 'event.dart';
import 'task.dart';
import 'topic.dart';

export 'event.dart';
export 'messageloader.dart';
export 'note.dart';
export 'task.dart';
export 'theme.dart';
export 'topic.dart';

DateFormat fullDateFormatter = DateFormat('d MMM y HH:mm');
DateFormat timeFormatter = DateFormat('HH:mm');

abstract class Message {
  late Topic topic;
  late DateTime timeCreated;
  late bool favourite;
  void onFavourite();
}

int getTypeId(Message o){
  return o.runtimeType==Task? 0 : o.runtimeType==Event? 1:2;
}
