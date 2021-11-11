import 'package:equatable/equatable.dart';

class Statistics extends Equatable {
  final String text;
  final int value;

  Statistics(
    this.text,
    this.value,
  );

  @override
  List<Object?> get props => [text, value];
}
