import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../model/category.dart';
import '../../model/record.dart';
import '../../utils/utils.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final Category category;

  CategoryBloc(this.category) : super(CategoryInitial(category));

  @override
  Stream<CategoryState> mapEventToState(
    CategoryEvent event,
  ) async* {
    if (event is FavoriteShowed) {
      yield FavoriteShowSuccess(category);
    } else if (event is AllShowed) {
      yield AllShowedSuccess(category);
    } else if (event is RecordFavorited) {
      category.favorite(event.record);
      yield RecordFavoriteSuccess(category, event.record);
      yield* mapEventToState(AllRecordsUnselected());
    } else if (event is RecordUnfavorited) {
      category.unfavorite(event.record);
      yield RecordUnfavoriteSuccess(category, event.record);
      yield* mapEventToState(AllRecordsUnselected());
    } else if (event is RecordFavoriteChanged) {
      if (event.record.isFavorite) {
        yield* mapEventToState(RecordUnfavorited(event.record));
      } else {
        yield* mapEventToState(RecordFavorited(event.record));
      }
    } else if (event is RecordsDeleteStarted) {
      yield RecordsDeleteInProcess(category, event.records);
    } else if (event is RecordsDeleted) {
      category.deleteAll(event.records);
      yield RecordDeleteSuccess(category);
    } else if (event is RecordsDeleteCancelled) {
      yield RecordDeleteCancelSuccess(category);
      yield* mapEventToState(AllRecordsUnselected());
    } else if (event is RecordsCopied) {
      copyToClipboard(event.records);
      yield* mapEventToState(AllRecordsUnselected());
      yield RecordsCopySuccess(category, event.records);
    } else if (event is AllRecordsUnselected) {
      for (var record in category.selectedRecords) {
        yield* mapEventToState(RecordUnselected(record));
      }
    } else if (event is RecordSelected) {
      category.select(event.record);
      yield RecordSelectSuccess(category, event.record);
    } else if (event is RecordUnselected) {
      category.unselect(event.record);
      yield RecordUnselectSuccess(category, event.record);
    } else if (event is RecordSelectChanged) {
      if (event.record.isSelected) {
        yield* mapEventToState(RecordUnselected(event.record));
      } else {
        yield* mapEventToState(RecordSelected(event.record));
      }
    } else if (event is RecordAdded) {
      category.add(event.record);
      yield RecordAddSuccess(category, event.record);
    } else if (event is RecordUpdateStarted) {
      yield RecordUpdateInProcess(category, event.record);
    } else if (event is RecordUpdateCancelled) {
      yield RecordUpdateCancelSuccess(category);
      yield* mapEventToState(AllRecordsUnselected());
    } else if (event is RecordUpdated) {
      category.update(event.record, newMessage: event.newMessage);
      yield RecordUpdateSuccess(category, event.record);
      yield* mapEventToState(AllRecordsUnselected());
    }
  }

  @override
  void onTransition(Transition<CategoryEvent, CategoryState> transition) {
    print(transition);
    super.onTransition(transition);
  }
}
