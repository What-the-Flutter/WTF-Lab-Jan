import 'package:equatable/equatable.dart';

import '../../../../models/note_with_category.dart';
import '../models/category_count.dart';

abstract class StatsState extends Equatable {
  const StatsState();

  @override
  List<Object?> get props => [];
}

class FetchingDataState extends StatsState {
  const FetchingDataState();
}

class InitialDataState extends FetchedNotesState {
  const InitialDataState()
      : super(
          notes: const [],
          categoryCountData: const [],
          categoryAmount: 0,
        );
}

class FetchedNotesState extends StatsState {
  final List<NoteWithCategory> notes;
  final List<CategoryCount> categoryCountData;
  final int categoryAmount;

  const FetchedNotesState({
    required this.notes,
    required this.categoryCountData,
    required this.categoryAmount,
  });

  @override
  List<Object?> get props => [notes, categoryCountData];
}
