part of 'filter_screen_cubit.dart';

class FilterScreenState extends Equatable {
  final ModeFilter modeFilter;
  final List<SearchItemData> pages;
  final List<SearchItemData> tags;
  final List<SearchItemData> labels;

  FilterScreenState({
    this.modeFilter,
    this.pages,
    this.tags,
    this.labels,
  });

  FilterScreenState copyWith({
    final ModeFilter modeFilter,
    final List<SearchItemData> pages,
    final List<SearchItemData> tags,
    final List<SearchItemData> labels,
  }) {
    return FilterScreenState(
      modeFilter: modeFilter ?? this.modeFilter,
      pages: pages ?? this.pages,
      tags: tags ?? this.tags,
      labels: labels ?? this.labels,
    );
  }

  @override
  List<Object> get props => [modeFilter, pages, tags, labels];
}
