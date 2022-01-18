import 'package:bloc/bloc.dart';

import '../../database/database.dart' as db;
import '../../database/message_loader.dart';
import '../../entity/entities.dart' as entity;
import 'items_page_state.dart';

class ItemsPageCubit extends Cubit<ItemsPageState> {
  ItemsPageCubit() : super(ItemsPageState.initial());

  void loadTopics() async {
    emit(state.duplicate(
      topics: await db.TopicLoader.loadTopics(),
    ));
  }

  void pinTopic(entity.Topic topic) {
    topic.onPin();
    db.TopicLoader.updateTopic(topic);
    update();
  }

  void archiveTopic(entity.Topic topic) {
    topic.onArchive();
    db.TopicLoader.updateTopic(topic);
    update();
  }

  void deleteTopic(entity.Topic topic) {
    db.TopicLoader.deleteTopic(topic);
    update();
  }

  void removeTask(entity.Task task) {
    MessageLoader.remove(task);
    emit(state.duplicate());
  }

  void completeTask(entity.Task task) {
    task.complete();
    emit(state.duplicate());
  }

  void visitEvent(entity.Event event) {
    event.visit();
    emit(state.duplicate());
  }

  void missEvent(entity.Event event) {
    event.miss();
    emit(state.duplicate());
  }

  void update() => emit(state.duplicate(topics: db.TopicLoader.getTopics()));
}
