part of 'timeline_screen_cubit.dart';

class TimelineScreenState extends Equatable {
  final ModeFilter modeFilter;
  final List<ModelMessage> list;
  final bool isBookmark;

  TimelineScreenState({
    this.modeFilter,
    this.list,
    this.isBookmark,
  });

  @override
  List<Object> get props => [modeFilter, list, isBookmark];

  TimelineScreenState copyWith({
    final ModeFilter modeFilter,
    final List<ModelMessage> list,
    final bool isBookmark,
  }) {
    return TimelineScreenState(
      modeFilter: modeFilter ?? this.modeFilter,
      list: list ?? this.list,
      isBookmark: isBookmark ?? this.isBookmark,
    );
  }
}
