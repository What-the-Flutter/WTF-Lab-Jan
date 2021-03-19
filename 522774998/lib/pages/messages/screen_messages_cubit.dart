import 'package:bloc/bloc.dart';

import '../../database/database.dart';
import '../../repository/messages_repository.dart';
import 'widgets/message/message_cubit.dart';

part 'screen_messages_state.dart';

class ScreenMessagesCubit extends Cubit<ScreenMessagesState> {
  MessagesRepository repository;
  final String title;
  final List<MessageCubit> list = <MessageCubit>[];
  final DBHelper _dbHelper = DBHelper();

  ScreenMessagesCubit({this.repository, this.title})
      : super(ScreenMessagesState());

  void updateList() {
    var index = 0;
    for (var i = repository.messages.length - 1; i > 0; i--) {
      list[index].edit(repository.messages[i].message);
      index++;
    }
  }

  void updateOnTap(bool isNull) {
    for (var i = 0; i < list.length; i++) {
      list[i].update(isNull);
    }
  }
}
