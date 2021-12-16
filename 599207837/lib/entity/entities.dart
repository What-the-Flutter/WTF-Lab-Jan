import 'package:intl/intl.dart';
import 'topic.dart';

export 'event.dart';
export 'note.dart';
export 'task.dart';
export 'topic.dart';

DateFormat dateFormatter = DateFormat('d MMM y HH:mm');

abstract class Message {
  late Topic topic;
}
