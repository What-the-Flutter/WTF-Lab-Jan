import 'package:equatable/equatable.dart';

import '../../../../../models/category.dart';
import '../../../../../models/tag.dart';

abstract class FilterState extends Equatable {
  const FilterState();

  @override
  List<Object?> get props => [];
}

class FetchingDataState extends FilterState {
  const FetchingDataState();
}

class InitialState extends FetchedDataState {
  InitialState() : super(tags: const [], categories: const []);
}

class FetchedDataState extends FilterState {
  final String query;
  final List<Tag> tags;
  final List<Category> categories;
  final List<Tag> selectedTags;
  final List<Category> selectedCategories;
  late final bool filtersEnabled;

  FetchedDataState({
    this.query = '',
    required this.tags,
    required this.categories,
    this.selectedTags = const [],
    this.selectedCategories = const [],
  }) {
    filtersEnabled = selectedTags.isNotEmpty || selectedCategories.isNotEmpty || query.isNotEmpty;
  }

  FetchedDataState copyWith({
    String? query,
    List<Tag>? selectedTags,
    List<Category>? selectedCategories,
  }) {
    return FetchedDataState(
      query: query ?? this.query,
      tags: tags,
      categories: categories,
      selectedTags: selectedTags ?? this.selectedTags,
      selectedCategories: selectedCategories ?? this.selectedCategories,
    );
  }

  @override
  List<Object?> get props => [query, tags, categories, selectedCategories, selectedTags];
}
