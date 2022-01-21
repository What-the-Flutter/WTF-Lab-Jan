import 'package:bloc/bloc.dart';

import '../../database/database.dart';
import '../../entity/entities.dart';
import 'items_page_state.dart';

class ItemsPageCubit extends Cubit<ItemsPageState> {
  ItemsPageCubit() : super(ItemsPageState.initial());

  void loadData() async {
    emit(state.duplicate(
      topics: await TopicLoader.loadTopics(),
      favTasks: await Task.getFavouriteTasks(),
      favEvents: await Event.getFavouriteEvents(),
      favNotes: await Note.getFavouriteNotes(),
    ));
  }

  void pinTopic(Topic topic) {
    topic.onPin();
    TopicLoader.updateTopic(topic);
    update();
  }

  void archiveTopic(Topic topic) {
    topic.onArchive();
    TopicLoader.updateTopic(topic);
    update();
  }

  void deleteTopic(Topic topic) {
    TopicLoader.deleteTopic(topic);
    update();
  }

  void removeTask(Task task) {
    MessageLoader.remove(task);
    emit(state.duplicate());
  }

  void completeTask(Task task) {
    MessageLoader.completeTask(task);
    emit(state.duplicate());
  }

  void visitEvent(Event event) {
    MessageLoader.visitEvent(event);
    emit(state.duplicate());
  }

  void missEvent(Event event) {
    MessageLoader.missEvent(event);
    emit(state.duplicate());
  }

  void update() => loadData();
}
