class ChatIcon {
  final String? id;
  final String iconTitle;

  ChatIcon({required this.iconTitle, required this.id});

  ChatIcon.fromMap(String key, Map<dynamic, dynamic> map)
      : id = key,
        iconTitle = map['iconTitle'];

  toJson() {
    return {
      'iconTitle': iconTitle,
    };
  }
}

final List<ChatIcon> chatIconsList = [
  ChatIcon(iconTitle: 'basketballBall', id: ''),
  ChatIcon(iconTitle: 'child_care', id: ''),
  ChatIcon(iconTitle: 'monetization_on', id: ''),
  ChatIcon(iconTitle: 'airport_shuttle', id: ''),
  ChatIcon(iconTitle: 'card_travel', id: ''),
  ChatIcon(iconTitle: 'directions_car', id: ''),
  ChatIcon(iconTitle: 'home', id: ''),
  ChatIcon(iconTitle: 'star', id: ''),
  ChatIcon(iconTitle: 'vpn_key', id: ''),
  ChatIcon(iconTitle: 'brush', id: ''),
  ChatIcon(iconTitle: 'title', id: ''),
  ChatIcon(iconTitle: 'favorite', id: ''),
  ChatIcon(iconTitle: 'book', id: ''),
  ChatIcon(iconTitle: 'nature_people', id: ''),
];
