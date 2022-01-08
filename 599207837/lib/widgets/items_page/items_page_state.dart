import '../../entity/entities.dart' as entity;

class ItemsPageState {
  late final List<entity.Message> favTasks;
  late final List<entity.Message> favEvents;
  late final List<entity.Message> favNotes;
  late final List<entity.Topic> topics;

  bool _topicsEdited = false;
  bool _tasksEdited = false;
  bool _eventsEdited = false;
  bool _notesEdited = false;

  bool get topicsEdited {
    if (_topicsEdited) {
      _topicsEdited = false;
      return true;
    }
    return false;
  }

  bool get tasksEdited {
    if (_tasksEdited) {
      _tasksEdited = false;
      return true;
    }
    return false;
  }

  bool get eventsEdited {
    if (_eventsEdited) {
      _eventsEdited = false;
      return true;
    }
    return false;
  }

  bool get notesEdited {
    if (_notesEdited) {
      _notesEdited = false;
      return true;
    }
    return false;
  }

  set topicsEdited(bool v) => _topicsEdited = v;

  set tasksEdited(bool v) => _tasksEdited = v;

  set eventsEdited(bool v) => _eventsEdited = v;

  set notesEdited(bool v) => _notesEdited = v;

  ItemsPageState() {
    loadItems();
  }

  void loadItems() {
    favTasks = entity.Task.getFavouriteTasks();
    favEvents = entity.Event.getFavouriteEvents();
    favNotes = entity.Note.getFavouriteNotes();
    topics = entity.Topic.topics;
  }
}
