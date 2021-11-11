class SectionIcon {
  final int? id;
  final String iconTitle;
  final String title;

  const SectionIcon(
      {required this.iconTitle, required this.title, required this.id});

  Map<String, dynamic> toMap() {
    return {
      'iconTitle': iconTitle,
      'title': title,
    };
  }

  factory SectionIcon.fromMap(Map<String, dynamic> map) {
    return SectionIcon(
      id: map['id'],
      iconTitle: map['iconTitle'],
      title: map['title'],
    );
  }
}

final List<SectionIcon> sectionIconsList = [
  const SectionIcon(iconTitle: 'clear', title: 'Cancel', id: -1),
  const SectionIcon(iconTitle: 'fastfood', title: 'FastFood', id: -1),
  const SectionIcon(iconTitle: 'movie', title: 'Movie', id: -1),
  const SectionIcon(iconTitle: 'local_laundry_service', title: 'Laundry', id: -1),
  const SectionIcon(iconTitle: 'directions_run', title: 'Running', id: -1),
  const SectionIcon(iconTitle: 'basketballBall', title: 'Sports', id: -1),
  const SectionIcon(iconTitle: 'child_care', title: 'Child', id: -1),
  const SectionIcon(iconTitle: 'access_alarm', title: 'Urgently', id: -1),
];
