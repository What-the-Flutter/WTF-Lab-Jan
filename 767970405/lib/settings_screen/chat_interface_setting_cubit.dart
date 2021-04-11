import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

part 'chat_interface_setting_state.dart';

class ChatInterfaceSettingCubit extends Cubit<ChatInterfaceSettingState> {
  ChatInterfaceSettingCubit() : super(ChatInterfaceSettingState());

  void changeBubbleAlign(bool value) {
    emit(state.copyWith(isLeftBubbleAlign: value));
  }

  void changeDateTimeModification(bool value) {
    emit(state.copyWith(isDateTimeModification: value));
  }

  void changeCenterDateBubble(bool value) {
    emit(state.copyWith(isCenterDateBubble: value));
  }

  void changeAuthentication(bool value) {
    emit(state.copyWith(isAuthentication: value));
  }

  void pickImage() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    emit(state.copyWith(pathBackgroundImage: pickedFile.path));
  }

  void unsetImage() {
    emit(state.copyWith(pathBackgroundImage: ''));
  }
}
