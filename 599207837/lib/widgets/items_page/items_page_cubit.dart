import 'package:bloc/bloc.dart';
import '../../entity/entities.dart';

import 'items_page_state.dart';

class ItemsPageCubit extends Cubit<ItemsPageState> {
  ItemsPageCubit() : super(ItemsPageState.initial());

  void pinTopic(Topic topic) {
    topic.onPin();
    emit(state.duplicate());
  }

  void archiveTopic(Topic topic) {
    topic.onArchive();
    emit(state.duplicate());
  }

  void deleteTopic(Topic topic) {
    topic.delete();
    emit(state.duplicate());
  }

  void removeTask(Task task) {
    MessageLoader.remove(task);
    emit(state.duplicate());
  }

  void completeTask(Task task) {
    task.complete();
    task.timeCompleted = DateTime.now();
    emit(state.duplicate());
  }

  void visitEvent(Event event) {
    event.visit();
    emit(state.duplicate());
  }

  void missEvent(Event event) {
    event.miss();
    emit(state.duplicate());
  }

  void update() => emit(state.duplicate());
}
