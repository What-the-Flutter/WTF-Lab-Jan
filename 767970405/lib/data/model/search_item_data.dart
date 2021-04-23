import 'package:equatable/equatable.dart';

class SearchItemData extends Equatable {
  final int id;
  final int indexIcon;
  final String name;
  final bool isSelected;

  SearchItemData({
    this.id,
    this.isSelected,
    this.indexIcon,
    this.name,
  });

  SearchItemData copyWith({
    final int id,
    final int indexIcon,
    final String name,
    final bool isSelected,
  }) {
    return SearchItemData(
      id: id ?? this.id,
      indexIcon: indexIcon ?? this.indexIcon,
      name: name ?? this.name,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  @override
  List<Object> get props => [id, indexIcon, name, isSelected];
}
