import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../database/database.dart';
import '../../entity/entities.dart';
import 'items_page_state.dart';

class ItemsPageCubit extends Cubit<ItemsPageState> {
  final List<StreamSubscription> _subs = [];

  ItemsPageCubit() : super(ItemsPageState.initial());

  @override
  Future<void> close() {
    for (var o in _subs) {
      o.cancel();
    }
    return super.close();
  }

  void subscribe() async {
    _subs.add(TopicRepository.loadTopics().listen(_updateTopics));
    _subs.add(Task.getFavouriteTasks().listen(_updateTasks));
    _subs.add(Event.getFavouriteEvents().listen(_updateEvents));
    _subs.add(Note.getFavouriteNotes().listen(_updateNotes));
  }

  Future<void> _updateTopics(List<Topic> data) async {
    await Future<void>.delayed(const Duration(milliseconds: 50));
    emit(state.duplicate(topics: data));
  }

  Future<void> _updateTasks(List<Message> data) async {
    await Future<void>.delayed(const Duration(milliseconds: 50));
    emit(state.duplicate(favTasks: data));
  }

  Future<void> _updateEvents(List<Message> data) async {
    await Future<void>.delayed(const Duration(milliseconds: 50));
    emit(state.duplicate(favEvents: data));
  }

  Future<void> _updateNotes(List<Message> data) async {
    await Future<void>.delayed(const Duration(milliseconds: 50));
    emit(state.duplicate(favNotes: data));
  }

  void pinTopic(Topic topic) {
    topic.onPin();
    TopicRepository.updateTopic(topic);
  }

  void archiveTopic(Topic topic) {
    topic.onArchive();
    TopicRepository.updateTopic(topic);
  }

  void deleteTopic(Topic topic) => TopicRepository.deleteTopic(topic);

  void removeTask(Task task) {
    MessageRepository.remove(task);
    emit(state.duplicate());
  }

  void completeTask(Task task) {
    MessageRepository.completeTask(task);
    emit(state.duplicate());
  }

  void visitEvent(Event event) {
    MessageRepository.visitEvent(event);
    emit(state.duplicate());
  }

  void missEvent(Event event) {
    MessageRepository.missEvent(event);
    emit(state.duplicate());
  }
}
