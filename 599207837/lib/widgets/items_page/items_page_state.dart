import '../../entity/entities.dart' as entity;

class ItemsPageState {
  static const List listPlug = [];

  late final List<entity.Message> favTasks;
  late final List<entity.Message> favEvents;
  late final List<entity.Message> favNotes;
  late final List<entity.Topic> topics;

  ItemsPageState({
    required this.topics,
    required this.favTasks,
    required this.favEvents,
    required this.favNotes,
  });

  ItemsPageState.initial() {
    favTasks = entity.Task.getFavouriteTasks();
    favEvents = entity.Event.getFavouriteEvents();
    favNotes = entity.Note.getFavouriteNotes();
    topics = entity.Topic.topics;
  }

  ItemsPageState duplicate({
    List<entity.Message>? favTasks,
    List<entity.Message>? favEvents,
    List<entity.Message>? favNotes,
    List<entity.Topic>? topics,
  }) {
    return ItemsPageState(
      topics: topics ?? this.topics,
      favTasks: favTasks ?? this.favTasks,
      favEvents: favEvents ?? this.favEvents,
      favNotes: favNotes ?? this.favNotes,
    );
  }
}
