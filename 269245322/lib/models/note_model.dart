class NoteModel {
  final int id;
  final String heading;
  final String data;
  final int icon;
  final bool isFavorite;
  final bool isSearched;
  final bool isChecked;
  final String? downloadURL;
  final String? tags;

  NoteModel({
    required this.id,
    required this.heading,
    required this.data,
    required this.icon,
    required this.isFavorite,
    required this.isSearched,
    required this.isChecked,
    this.downloadURL,
    this.tags,
  });

  NoteModel copyWith({
    int? id,
    String? heading,
    String? data,
    int? icon,
    bool? isFavorite,
    bool? isSearched,
    bool? isChecked,
    String? downloadURL,
    String? tags,
  }) {
    return NoteModel(
      id: id ?? this.id,
      heading: heading ?? this.heading,
      data: data ?? this.data,
      icon: icon ?? this.icon,
      isFavorite: isFavorite ?? this.isFavorite,
      isSearched: isSearched ?? this.isSearched,
      isChecked: isChecked ?? this.isChecked,
      downloadURL: downloadURL ?? this.downloadURL,
      tags: tags ?? this.tags,
    );
  }

  Map<String, dynamic> toMap(String pageTitle) {
    return {
      'id': id,
      'heading': heading,
      'title': pageTitle,
      'data': data,
      'icon': icon,
      'is_favorite': isFavorite ? 1 : 0,
      'is_searched': isSearched ? 1 : 0,
      'is_checked': isChecked ? 1 : 0,
    };
  }

  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      id: map['id'],
      heading: map['heading'],
      data: map['data'],
      icon: map['icon'],
      isFavorite: map['is_favorite'] == 0 ? false : true,
      isSearched: map['is_searched'] == 0 ? false : true,
      isChecked: map['is_checked'] == 0 ? false : true,
      tags: map['tags'],
    );
  }
  factory NoteModel.fromMapFireBase(Map<dynamic, dynamic> map) {
    return NoteModel(
      id: map['id'],
      heading: map['heading'],
      data: map['data'],
      icon: map['icon'],
      isFavorite: map['is_favorite'],
      isSearched: map['is_searched'],
      isChecked: map['is_checked'],
      downloadURL: map['download_URL'],
      tags: map['tags'],
    );
  }
}
