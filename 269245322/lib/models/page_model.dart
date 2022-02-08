import 'note_model.dart';

class PageModel {
  final String title;
  final String? fireBaseTitle;
  final int icon;
  final int numOfNotes;
  final List<NoteModel> notesList;

  final String cretionDate;
  String get getCretionDate => cretionDate;
  final String lastModifedDate;
  String get getlastModifedDate => lastModifedDate;

  PageModel({
    required this.title,
    required this.icon,
    required this.cretionDate,
    required this.notesList,
    required this.numOfNotes,
    required this.lastModifedDate,
    this.fireBaseTitle,
  });

  PageModel copyWith({
    String? title,
    String? fireBaseTitle,
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
      fireBaseTitle: this.fireBaseTitle,
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
      fireBaseTitle: dbPageNum,
      icon: map['icon'] ?? 0,
      numOfNotes: map['num_of_notes'] ?? 0,
      notesList: [],
      cretionDate: map['cretion_date'] ?? ' ',
      lastModifedDate: map['last_modifed_date'] ?? ' ',
    );
  }
}
