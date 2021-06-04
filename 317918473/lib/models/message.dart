import 'package:equatable/equatable.dart';

class Messages extends Equatable {
  final DateTime date;
  final String? message;
  final String? pathImage;
  final bool isEdit;
  final bool isFavorite;
  final bool isSelect;

  Messages(
    this.date, {
    this.message,
    this.pathImage,
    this.isEdit = false,
    this.isFavorite = false,
    this.isSelect = false,
  });

  @override
  List<Object?> get props =>
      [date, message, pathImage, isEdit, isFavorite, isSelect];

  Messages copyWith({
    DateTime? date,
    String? message,
    String? pathImage,
    bool? isEdit,
    bool? isFavorite,
    bool? isSelect,
  }) {
    return Messages(
      date ?? this.date,
      message: message ?? this.message,
      pathImage: pathImage ?? this.pathImage,
      isEdit: isEdit ?? this.isEdit,
      isFavorite: isFavorite ?? this.isFavorite,
      isSelect: isSelect ?? this.isSelect,
    );
  }
}
