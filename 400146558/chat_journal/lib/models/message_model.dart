import 'package:chat_journal/models/sectionicon_model.dart';
import 'package:jiffy/jiffy.dart';

class Message {
  String message;
  final Jiffy time;
  bool isFavourite;
  bool isSelected;
  SectionIcon? section;

  Message(this.message, this.time, this.isFavourite, this.isSelected, this.section);
}

