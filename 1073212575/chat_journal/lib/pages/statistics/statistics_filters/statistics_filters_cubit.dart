import 'package:bloc/bloc.dart';
import 'package:chat_journal/models/filter_parameters.dart';
import 'package:chat_journal/pages/statistics/statistics_filters/statistics_filters_state.dart';
import 'package:chat_journal/repository/pages_repository.dart';

class StatisticsFiltersPageCubit extends Cubit<StatisticsFiltersPageState> {
  final PagesRepository pagesRepository;

  StatisticsFiltersPageCubit(this.pagesRepository)
      : super(
          StatisticsFiltersPageState(
            isColorChanged: false,
            eventPages: [],
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

  FilterParameters filterParameters() {
    return state.parameters;
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
