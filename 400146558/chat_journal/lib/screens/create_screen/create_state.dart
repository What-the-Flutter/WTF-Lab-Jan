import 'package:chat_journal/models/chaticon_model.dart';

class CreatePageState {
  final List<ChatIcon> iconsList;

  CreatePageState({
    this.iconsList = const [],
  });

  CreatePageState copyWith({
    List<ChatIcon>? iconsList,
  }) {
    return CreatePageState(
      iconsList: iconsList ?? this.iconsList,
    );
  }
}
