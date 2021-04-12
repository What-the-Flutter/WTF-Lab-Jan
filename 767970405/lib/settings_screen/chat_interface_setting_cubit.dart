import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'chat_interface_setting_state.dart';

class ChatInterfaceSettingCubit extends Cubit<ChatInterfaceSettingState> {
  ChatInterfaceSettingCubit() : super(ChatInterfaceSettingState()) {
    loadAllSettings();
  }

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

  void loadAllSettings() async {
    emit(state.copyWith(
      isDateTimeModification: await loadChatInterfaceSettings('timeModification'),
      isLeftBubbleAlign: await loadChatInterfaceSettings('bubbleAlign'),
      isCenterDateBubble: await loadChatInterfaceSettings('dateBubble'),
      isAuthentication: await loadChatInterfaceSettings('auth'),
      pathBackgroundImage: await loadBackgroundImage(),
    ));
  }

  Future<bool> loadChatInterfaceSettings(String key) async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? false;
  }

  Future<String> loadBackgroundImage() async {
    var prefs = await SharedPreferences.getInstance();
    var str = prefs.getString('backgroundImage');
    return str;
  }

  Future<void> saveBackgroundImage(String path) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString('backgroundImage', path);
  }

  Future<void> saveChatInterfaceSettings(String key, bool state) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, state);
  }
}
