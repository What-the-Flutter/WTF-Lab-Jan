import 'package:equatable/equatable.dart';

class ModelPage extends Equatable implements Comparable<ModelPage> {
  final int id;
  final String title;
  final int iconIndex;
  final bool isPinned;
  final DateTime creationTime;
  final DateTime lastModifiedTime;

  ModelPage({
    this.isPinned,
    this.iconIndex,
    this.title,
    this.id,
    this.creationTime,
    this.lastModifiedTime,
  });

  ModelPage copyWith({
    final bool isPinned,
    final int iconIndex,
    final String title,
    final int id,
    final DateTime creationTime,
    final DateTime lastModifiedTime,
  }) {
    return ModelPage(
      isPinned: isPinned ?? this.isPinned,
      iconIndex: iconIndex ?? this.iconIndex,
      title: title ?? this.title,
      id: id ?? this.id,
      creationTime: creationTime ?? this.creationTime,
      lastModifiedTime: lastModifiedTime ?? this.lastModifiedTime,
    );
  }

  @override
  int compareTo(ModelPage other) {
    if (isPinned && !other.isPinned) {
      return -1;
    } else if (!isPinned && other.isPinned) {
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
      [id, isPinned, iconIndex, title, lastModifiedTime, creationTime];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'iconIndex': iconIndex,
      'isPinned': isPinned ? 1 : 0,
      'creationTime': creationTime.toString(),
      'lastModifiedTime': lastModifiedTime.toString(),
    };
  }
}
