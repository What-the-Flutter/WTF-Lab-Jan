import '../../entity/entities.dart';

class ItemsPageState {
  static const List _listPlug = [];

  late final List<Message> favTasks;
  late final List<Message> favEvents;
  late final List<Message> favNotes;
  late final List<Topic> topics;

  ItemsPageState({
    required this.topics,
    required this.favTasks,
    required this.favEvents,
    required this.favNotes,
  });

  ItemsPageState.initial() {
    favTasks = [];
    favEvents = [];
    favNotes = [];
    topics = [];
  }

  ItemsPageState duplicate({
    List<Message>? favTasks,
    List<Message>? favEvents,
    List<Message>? favNotes,
    List<Topic>? topics,
  }) {
    return ItemsPageState(
      topics: topics ?? this.topics,
      favTasks: favTasks ?? this.favTasks,
      favEvents: favEvents ?? this.favEvents,
      favNotes: favNotes ?? this.favNotes,
    );
  }
}
