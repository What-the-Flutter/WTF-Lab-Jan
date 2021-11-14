class ChatIcon {
  final int id;
  final String iconTitle;

  ChatIcon({required this.iconTitle, required this.id});

  Map<String, dynamic> toMap() {
    return {
      'iconTitle': iconTitle,
    };
  }

  factory ChatIcon.fromMap(Map<String, dynamic> map) {
    return ChatIcon(
      id: map['id'],
      iconTitle: map['iconTitle'],
    );
  }
}

final List<ChatIcon> chatIconsList = [
  ChatIcon(iconTitle: 'basketballBall', id: -1),
  ChatIcon(iconTitle: 'child_care', id: -1),
  ChatIcon(iconTitle: 'monetization_on', id: -1),
  ChatIcon(iconTitle: 'airport_shuttle', id: -1),
  ChatIcon(iconTitle: 'card_travel', id: -1),
  ChatIcon(iconTitle: 'directions_car', id: -1),
  ChatIcon(iconTitle: 'home', id: -1),
  ChatIcon(iconTitle: 'star', id: -1),
  ChatIcon(iconTitle: 'vpn_key', id: -1),
  ChatIcon(iconTitle: 'brush', id: -1),
  ChatIcon(iconTitle: 'title', id: -1),
  ChatIcon(iconTitle: 'favorite', id: -1),
  ChatIcon(iconTitle: 'book', id: -1),
  ChatIcon(iconTitle: 'nature_people', id: -1),
];
