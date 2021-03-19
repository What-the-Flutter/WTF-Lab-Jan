import 'package:intl/intl.dart';

class PropertyPage implements Comparable<PropertyPage> {
  final int id;
  final bool isPin;
  final int iconIndex;
  final String title;
  final DateTime creationTime;
  final DateTime lastModifiedTime;

  PropertyPage({
    this.id,
    this.isPin = false,
    this.iconIndex,
    this.title,
    this.creationTime,
    this.lastModifiedTime,
  });

  PropertyPage copyWith({
    int id,
    final bool isPin,
    final int iconIndex,
    final String title,
    final DateTime creationTime,
    final DateTime lastModifiedTime,
  }) {
    return PropertyPage(
      id: id ?? this.id,
      isPin: isPin ?? this.isPin,
      iconIndex: iconIndex ?? this.iconIndex,
      title: title ?? this.title,
      creationTime: creationTime ?? this.creationTime,
      lastModifiedTime: lastModifiedTime ?? this.lastModifiedTime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'icon_index': iconIndex,
      'creation_time': DateFormat('yyyy-MM-dd hh:mm:ss').format(creationTime),
      'last_modified_time':
          DateFormat('yyyy-MM-dd hh:mm:ss').format(lastModifiedTime),
      'is_pin': isPin ? 1 : 0,
    };
  }

  factory PropertyPage.fromMap(Map<String, dynamic> map) => PropertyPage(
    id: map['id'],
    title: map['title'],
    iconIndex: map['icon_index'],
    creationTime:
    DateFormat('yyyy-MM-dd hh:mm:ss').parse(map['creation_time']),
    lastModifiedTime:
    DateFormat('yyyy-MM-dd hh:mm:ss').parse(map['last_modified_time']),
    isPin: map['is_pin'] == 1 ? true : false,
  );

  @override
  String toString() {
    return 'PropertyPage{isPin: $isPin, icon: $iconIndex, title: $title}';
  }

  @override
  int compareTo(PropertyPage other) {
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
}
