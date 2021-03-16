import 'package:equatable/equatable.dart';

class ModelPage extends Equatable implements Comparable<ModelPage> {
  final int id;
  final String title;
  final int iconIndex;
  final bool isPin;
  final DateTime creationTime;
  final DateTime lastModifiedTime;

  ModelPage({
    this.isPin,
    this.iconIndex,
    this.title,
    this.id,
    this.creationTime,
    this.lastModifiedTime,
  });

  ModelPage copyWith({
    final bool isPin,
    final int iconIndex,
    final String title,
    final int id,
    final DateTime creationTime,
    final DateTime lastModifiedTime,
  }) {
    return ModelPage(
      isPin: isPin ?? this.isPin,
      iconIndex: iconIndex ?? this.iconIndex,
      title: title ?? this.title,
      id: id ?? this.id,
      creationTime: creationTime ?? this.creationTime,
      lastModifiedTime: lastModifiedTime ?? this.lastModifiedTime,
    );
  }

  @override
  int compareTo(ModelPage other) {
    if (isPin && !other.isPin) {
      return -1;
    } else if (!isPin && other.isPin) {
      return 1;
    } else {
      if (creationTime.isBefore(other.creationTime)) {
        return -1;
      } else {
        return 1;
      }
    }
  }

  @override
  List<Object> get props =>
      [id, isPin, iconIndex, title, lastModifiedTime, creationTime];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'iconIndex': iconIndex,
      'isPin': isPin ? 1 : 0,
      'creationTime': creationTime.toString(),
      'lastModifiedTime': lastModifiedTime.toString(),
    };
  }
}
