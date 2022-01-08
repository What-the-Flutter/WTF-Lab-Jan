import 'package:bloc/bloc.dart';
import '../../entity/entities.dart';

import 'items_page_state.dart';

class ItemsPageCubit extends Cubit<ItemsPageState> {
  ItemsPageCubit() : super(ItemsPageState());

  void onTopicsChange() {
    emit(ItemsPageState()..topicsEdited = true);
  }

  void pinTopic(Topic topic) {
    topic.onPin();
    onTopicsChange();
  }

  void archiveTopic(Topic topic) {
    topic.onArchive();
    onTopicsChange();
  }

  void deleteTopic(Topic topic) {
    topic.delete();
    onTopicsChange();
  }

  void removeTask(Task task) {
    MessageLoader.remove(task);
    emit(ItemsPageState()..tasksEdited = true);
  }

  void completeTask(Task task) {
    task.complete();
    task.timeCompleted = DateTime.now();
    emit(ItemsPageState()..tasksEdited = true);
  }

  void visitEvent(Event event) {
    event.visit();
    emit(ItemsPageState()..eventsEdited = true);
  }

  void missEvent(Event event) {
    event.miss();
    emit(ItemsPageState()..eventsEdited = true);
  }
}
