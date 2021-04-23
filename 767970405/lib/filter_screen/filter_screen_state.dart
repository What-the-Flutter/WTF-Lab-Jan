part of 'filter_screen_cubit.dart';

class FilterScreenState extends Equatable {
  final ModeFilter modeFilter;
  final ModeFilterScreen modeFilterScreen;
  final List<SearchItemData> pages;
  final List<SearchItemData> tags;
  final List<SearchItemData> labels;

  FilterScreenState({
    this.modeFilter,
    this.modeFilterScreen,
    this.pages,
    this.tags,
    this.labels,
  });

  FilterScreenState copyWith({
    final ModeFilter modeFilter,
    final ModeFilterScreen modeFilterScreen,
    final List<SearchItemData> pages,
    final List<SearchItemData> tags,
    final List<SearchItemData> labels,
  }) {
    return FilterScreenState(
      modeFilter: modeFilter ?? this.modeFilter,
      modeFilterScreen: modeFilterScreen ?? this.modeFilterScreen,
      pages: pages ?? this.pages,
      tags: tags ?? this.tags,
      labels: labels ?? this.labels,
    );
  }

  @override
  List<Object> get props => [modeFilter, pages, tags, labels, modeFilterScreen];
}
