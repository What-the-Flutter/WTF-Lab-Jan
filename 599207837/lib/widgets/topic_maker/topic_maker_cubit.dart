import 'package:bloc/bloc.dart';
import '../../database/database.dart';
import '../../entity/entities.dart';
import 'topic_maker_state.dart';

class TopicMakerCubit extends Cubit<TopicMakerState> {
  TopicMakerCubit() : super(TopicMakerState.initial());

  TopicMakerCubit.editing(Topic topic) : super(TopicMakerState.editing(topic));

  void finish() {
    if (state.topic == null) {
      TopicRepository.addNewTopic(
        Topic(
          name: state.nameController!.text,
          icon: TopicMakerState.icons[state.selected],
        ),
      );
    } else {
      TopicRepository.editTopic(
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
