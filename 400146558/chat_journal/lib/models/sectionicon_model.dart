class SectionIcon {
  final String? id;
  final String iconTitle;
  final String title;

  const SectionIcon(
      {required this.iconTitle, required this.title, required this.id});

  SectionIcon.fromMap(String key, Map<dynamic, dynamic> map)
      : id = key,
        iconTitle = map['iconTitle'],
        title = map['title'];

  toJson() {
    return {
      'iconTitle': iconTitle,
      'title': title,
    };
  }
}

final List<SectionIcon> sectionIconsList = [
  const SectionIcon(iconTitle: 'clear', title: 'Cancel', id: ''),
  const SectionIcon(iconTitle: 'fastfood', title: 'FastFood', id: ''),
  const SectionIcon(iconTitle: 'movie', title: 'Movie', id: ''),
  const SectionIcon(
      iconTitle: 'local_laundry_service', title: 'Laundry', id: ''),
  const SectionIcon(iconTitle: 'directions_run', title: 'Running', id: ''),
  const SectionIcon(iconTitle: 'basketballBall', title: 'Sports', id: ''),
  const SectionIcon(iconTitle: 'child_care', title: 'Child', id: ''),
  const SectionIcon(iconTitle: 'access_alarm', title: 'Urgently', id: ''),
];
