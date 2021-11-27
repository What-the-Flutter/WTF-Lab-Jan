import 'package:bloc/bloc.dart';
import '../../models/categories.dart';
import '../../models/filter_parameters.dart';
import '../../repository/messages_repository.dart';
import '../../repository/pages_repository.dart';

import 'filters_state.dart';

class FiltersPageCubit extends Cubit<FiltersPageState> {
  final PagesRepository pagesRepository;
  final MessagesRepository messagesRepository;

  FiltersPageCubit(this.pagesRepository, this.messagesRepository)
      : super(
          FiltersPageState(
            isColorChanged: false,
            eventPages: [],
            hashTags: [],
            parameters: FilterParameters(
              onlyCheckedMessages: false,
              isDateSelected: false,
              arePagesIgnored: true,
              selectedPages: [],
              selectedTags: [],
              selectedLabels: [],
              searchText: '',
              date: DateTime.now(),
            ),
          ),
        );

  void init() {
    gradientAnimation();
    showPages();
    showTags();
  }

  void showPages() async {
    final pages = await pagesRepository.eventPagesList();
    emit(
      state.copyWith(
        eventPages: pages,
      ),
    );
  }

  void changeIgnorePages() {
    final parameters = state.parameters.copyWith(
      isDateSelected: true,
      arePagesIgnored: !state.parameters.arePagesIgnored,
    );
    emit(
      state.copyWith(
        parameters: parameters,
      ),
    );
  }

  void onPagePressed(String pageId) {
    isPageSelected(pageId) ? unselectPage(pageId) : selectPage(pageId);
  }

  bool isPageSelected(String pageId) {
    return state.parameters.selectedPages.contains(pageId);
  }

  void selectPage(String pageId) {
    final pages = state.parameters.selectedPages;
    pages.add(pageId);
    final parameters = state.parameters.copyWith(
      selectedPages: pages,
    );
    emit(
      state.copyWith(
        parameters: parameters,
      ),
    );
  }

  void unselectPage(String pageId) {
    final pages = state.parameters.selectedPages;
    pages.remove(pageId);
    final parameters = state.parameters.copyWith(
      selectedPages: pages,
    );
    emit(
      state.copyWith(
        parameters: parameters,
      ),
    );
  }

  String pagesInfo() {
    var info;
    if (state.parameters.selectedPages.isEmpty) {
      info =
          'Tap to select a page you want to include to the filter. All pages are included by default';
    } else if (state.parameters.arePagesIgnored) {
      info = '${state.parameters.selectedPages.length} page(s) ignored';
    } else {
      info = '${state.parameters.selectedPages.length} page(s) included';
    }
    return info;
  }

  void showTags() async {
    final messages = await messagesRepository.allMessagesList();
    final hashTags = [];
    final exp = RegExp(
      r'\B#[0-9a-zA-Zа-яёА-ЯЁ]+',
    );
    for (var message in messages) {
      exp.allMatches(message.text).forEach((match) {
        if (!hashTags.contains(match.group(0))) {
          hashTags.add(match.group(0));
        }
      });
    }
    emit(
      state.copyWith(
        hashTags: hashTags,
      ),
    );
  }

  void onTagsPressed(String tag) {
    isTagSelected(tag) ? unselectTag(tag) : selectTag(tag);
  }

  bool isTagSelected(String tag) {
    return state.parameters.selectedTags.contains(tag);
  }

  void selectTag(String tag) {
    final tags = state.parameters.selectedTags;
    tags.add(tag);
    final parameters = state.parameters.copyWith(
      selectedTags: tags,
    );
    emit(
      state.copyWith(
        parameters: parameters,
      ),
    );
  }

  void unselectTag(String tag) {
    final tags = state.parameters.selectedTags;
    tags.remove(tag);
    final parameters = state.parameters.copyWith(
      selectedTags: tags,
    );
    emit(
      state.copyWith(
        parameters: parameters,
      ),
    );
  }

  String tagsInfo() {
    var info;
    if (state.parameters.selectedTags.isEmpty) {
      info =
          'Tap to select a tag you want to include to the filter. All tags are included by default';
    } else {
      info = '${state.parameters.selectedTags.length} tag(s) included';
    }
    return info;
  }

  void onLabelPressed(Category category) {
    isLabelSelected(category) ? unselectLabel(category) : selectLabel(category);
  }

  bool isLabelSelected(Category category) {
    return state.parameters.selectedLabels.contains(category.icon);
  }

  void selectLabel(Category category) {
    final categories = state.parameters.selectedLabels;
    categories.add(category.icon);
    final parameters = state.parameters.copyWith(
      selectedLabels: categories,
    );
    emit(
      state.copyWith(
        parameters: parameters,
      ),
    );
  }

  void unselectLabel(Category category) {
    final categories = state.parameters.selectedLabels;
    categories.remove(category.icon);
    final parameters = state.parameters.copyWith(
      selectedLabels: categories,
    );
    emit(
      state.copyWith(
        parameters: parameters,
      ),
    );
  }

  String labelsInfo() {
    var info;
    if (state.parameters.selectedLabels.isEmpty) {
      info =
          'Tap to select a label you want to include to the filter. All labels are included by default';
    } else {
      info = '${state.parameters.selectedLabels.length} label(s) included';
    }
    return info;
  }

  FilterParameters filterParameters() {
    return state.parameters;
  }

  void setSearchText(String text) {
    final parameters = state.parameters.copyWith(
      searchText: text,
    );
    emit(
      state.copyWith(
        parameters: parameters,
      ),
    );
  }

  void changeCheckedMessagesDisplay() {
    final parameters = state.parameters.copyWith(
      onlyCheckedMessages: !state.parameters.onlyCheckedMessages,
    );
    emit(
      state.copyWith(
        parameters: parameters,
      ),
    );
  }

  void setDate(DateTime? newDate) {
    if (newDate != null && newDate != state.parameters.date) {
      final parameters = state.parameters.copyWith(
        isDateSelected: true,
        date: newDate,
      );
      emit(
        state.copyWith(
          parameters: parameters,
        ),
      );
    }
  }

  void resetDate() {
    final parameters = state.parameters.copyWith(
      isDateSelected: false,
    );
    emit(
      state.copyWith(
        parameters: parameters,
      ),
    );
  }

  void gradientAnimation() async {
    emit(
      state.copyWith(
        isColorChanged: false,
      ),
    );
    await Future.delayed(
      const Duration(milliseconds: 30),
    );
    emit(
      state.copyWith(
        isColorChanged: true,
      ),
    );
  }
}
