import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../data/constants/constants.dart';
import '../data/model/model_message.dart';
import '../data/model/model_page.dart';
import '../data/model/model_tag.dart';
import '../data/repository/messages_repository.dart';

part 'search_message_screen_state.dart';

class SearchMessageScreenCubit extends Cubit<SearchMessageScreenState> {
  final controller = TextEditingController();
  final MessagesRepository repository;

  SearchMessageScreenCubit({
    this.repository,
  }) : super(SearchMessageScreenState(type: ResultSearch.wait)) {
    controller.addListener(() {
      if (isReset()) {
        emit(state.copyWith(
          type: ResultSearch.wait,
        ));
      } else {
        search();
      }
    });
  }

  bool isNotEmptyTag() {
    return state.tags.isNotEmpty;
  }

  @override
  Future<Function> close() {
    controller.dispose();
    return super.close();
  }

  void search() async {
    var list = state.modeScreen == ModeScreen.onePage
        ? await repository.messages(state.page.id)
        : await repository.messages();
    var selectedTags =
        state.tags.where((element) => element.isSelected).toList();
    var substring = controller.text;

    list = list.where((element) {
      var words = element.text.split(' ');
      if (selectedTags.isNotEmpty && substring.isNotEmpty) {
        return _searchForTag(words, selectedTags) ||
            _searchForText(words, substring);
      }
      if (selectedTags.isNotEmpty && substring.isEmpty) {
        return _searchForTag(words, selectedTags);
      }
      if (substring.isNotEmpty && selectedTags.isEmpty) {
        return _searchForText(words, substring);
      } else {
        return false;
      }
    }).toList();

    emit(
      state.copyWith(
        type: list.isEmpty ? ResultSearch.notFound : ResultSearch.found,
        list: list,
      ),
    );
  }

  bool _searchForTag(List<String> words, List<ModelTag> selectedTags) {
    for (var i = 0; i < selectedTags.length; i++) {
      for (var j = 0; j < words.length; j++) {
        if (words[j] == selectedTags[i].name) {
          return true;
        }
      }
    }
    return false;
  }

  bool _searchForText(List<String> words, String subString) {
    for (var i = 0; i < words.length; i++) {
      if (!words[i].startsWith('#') && words[i].contains(subString)) {
        return true;
      }
    }
    return false;
  }

  bool isReset() {
    return state.tags.where((element) => element.isSelected).toList().isEmpty &&
        controller.text.isEmpty;
  }

  void configureTagSearch(int index, bool isSelected) async {
    state.tags[index] = state.tags[index].copyWith(isSelected: isSelected);
    emit(
      state.copyWith(
        type: isReset() ? ResultSearch.wait : state.type,
        tags: List.from(state.tags),
      ),
    );
    if (!isReset()) {
      search();
    }
  }

  void reset() {
    controller.text = '';
  }

  bool isTextEmpty() => controller.text.isEmpty;

  void updateTag() async {
    emit(
      state.copyWith(
        tags: await repository.tags(),
      ),
    );
  }

  void setting(ModeScreen mode, [ModelPage page]) async {
    emit(
      state.copyWith(
        modeScreen: mode,
        page: page,
        tags: await repository.tags(),
      ),
    );
  }
}
