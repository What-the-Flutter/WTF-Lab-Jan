import 'package:chat_journal/models/chat_model.dart';
import 'package:chat_journal/models/chaticon_model.dart';
import 'package:chat_journal/util/db_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'create_state.dart';

class CreatePageCubit extends Cubit<CreatePageState> {
  CreatePageCubit() : super(CreatePageState());

  Future<void> init(Chat? editingChat) async {
    emit(
      state.copyWith(iconsList: await DBProvider.db.fetchChatIconsList()),
    );
    if (editingChat != null) {
      emit(state.copyWith(selectedChatIcon: editingChat.chatIcon));
    } else {
      emit(state.copyWith(selectedChatIcon: state.iconsList[0]));
    }
  }

  void check(ChatIcon chatIcon) {
    emit(state.copyWith(selectedChatIcon: chatIcon));
  }
}
