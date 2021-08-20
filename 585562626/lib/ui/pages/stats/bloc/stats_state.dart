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
  const InitialDataState() : super(const [], categoryCountData: const []);
}

class FetchedNotesState extends StatsState {
  final List<NoteWithCategory> notes;
  final List<CategoryCount> categoryCountData;

  const FetchedNotesState(this.notes, {required this.categoryCountData});

  @override
  List<Object?> get props => [notes, categoryCountData];
}
