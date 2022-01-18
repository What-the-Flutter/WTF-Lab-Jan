import 'package:bloc/bloc.dart';
import '../../database/database.dart' as db;
import '../../entity/entities.dart' as entity;
import 'topic_maker_state.dart';

class TopicMakerCubit extends Cubit<TopicMakerState> {
  TopicMakerCubit() : super(TopicMakerState.initial());

  TopicMakerCubit.editing(entity.Topic topic) : super(TopicMakerState.editing(topic));

  void finish() {
    if (state.topic == null) {
      db.TopicLoader.addNewTopic(
        entity.Topic(
          name: state.nameController!.text,
          icon: TopicMakerState.icons[state.selected],
        ),
      );
    } else {
      db.TopicLoader.editTopic(
        state.topic!,
        state.nameController!.text,
        TopicMakerState.icons[state.selected],
      );
    }
  }

  void changeSelected(int value) {
    emit(state.duplicate(selected: value));
  }

  void update() => emit(state.duplicate());
}
