import 'note_model.dart';

class PageModel {
  final String title;
  final String? dbTitle;
  final int icon;
  late final int numOfNotes;
  late final List<NoteModel> notesList;

  final String cretionDate;
  String get getCretionDate => cretionDate;
  late final String lastModifedDate;
  String get getlastModifedDate => lastModifedDate;

  PageModel({
    required this.title,
    required this.icon,
    required this.cretionDate,
    required this.notesList,
    required this.numOfNotes,
    required this.lastModifedDate,
    this.dbTitle,
  });

  PageModel copyWith({
    String? title,
    String? dbTitle,
    int? icon,
    int? numOfNotes,
    String? lastModifedDate,
    String? cretionDate,
    List<NoteModel>? notesList,
  }) {
    return PageModel(
      title: title ?? this.title,
      icon: icon ?? this.icon,
      numOfNotes: numOfNotes ?? this.numOfNotes,
      lastModifedDate: lastModifedDate ?? this.lastModifedDate,
      notesList: notesList ?? this.notesList,
      cretionDate: cretionDate ?? this.cretionDate,
      dbTitle: this.dbTitle,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'icon': icon,
      'num_of_notes': numOfNotes,
      'cretion_date': cretionDate,
      'last_modifed_date': lastModifedDate,
    };
  }

  factory PageModel.fromMap(Map<String, dynamic> map) {
    return PageModel(
      title: map['title'] ?? ' ',
      icon: map['icon'] ?? 0,
      numOfNotes: map['num_of_notes'] ?? 0,
      notesList: [],
      cretionDate: map['cretion_date'] ?? ' ',
      lastModifedDate: map['last_modifed_date'] ?? ' ',
    );
  }

  factory PageModel.fromMapFireBase(
      Map<dynamic, dynamic> map, String dbPageNum) {
    return PageModel(
      title: map['title'] ?? ' ',
      dbTitle: dbPageNum,
      icon: map['icon'] ?? 0,
      numOfNotes: map['num_of_notes'] ?? 0,
      notesList: [],
      cretionDate: map['cretion_date'] ?? ' ',
      lastModifedDate: map['last_modifed_date'] ?? ' ',
    );
  }
}
