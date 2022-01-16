import 'package:bloc/bloc.dart';
import '../../entity/entities.dart';
import 'topic_maker_state.dart';

class TopicMakerCubit extends Cubit<TopicMakerState> {
  TopicMakerCubit() : super(TopicMakerState.initial());

  TopicMakerCubit.editing(Topic topic) : super(TopicMakerState.editing(topic));

  void finish() {
    if (state.topic == null) {
      Topic.topics.add(Topic(
        name: state.nameController!.text,
        icon: TopicMakerState.icons[state.selected],
      ));
    } else {
      if (state.topic!.name != state.nameController!.text) {
        topics.remove(state.topic!.name);
        state.topic!.name = state.nameController!.text;
        topics[state.topic!.name] = state.topic!;
      }
      state.topic!.icon = TopicMakerState.icons[state.selected];
    }
  }

  void changeSelected(int value) {
    state.selected = value;
    emit(state.duplicate(selected: value));
  }

  void update() => emit(state.duplicate());
}
