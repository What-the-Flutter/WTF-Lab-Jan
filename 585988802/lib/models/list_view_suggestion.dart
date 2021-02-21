import 'event_message.dart';

///This class implements the structure of ListViewSuggestion's row.
class ListViewSuggestion {
  final List<EventMessage> eventMessagesList = <EventMessage>[];
  final String infoOfSuggestion = 'No Events. Click to create one.';
  String nameOfSuggestion;
  String imagePathOfSuggestion;
  int isPinned = 0;

  ListViewSuggestion(this.nameOfSuggestion, this.imagePathOfSuggestion);
}
