import 'package:shared_preferences/shared_preferences.dart';

final List<JournalPage> pages = [];

class JournalPage {
  static int _idCount = 0;

  static void initCount() async {
    final prefs = await SharedPreferences.getInstance();
    _idCount = prefs.getInt('pageId') ?? 0;
  }

  static void updateId() async {
    final prefs = await SharedPreferences.getInstance();
    _idCount++;
    prefs.setInt('pageId', _idCount);
  }

  int? _id;
  String title;
  int iconIndex;
  bool isPinned = false;
  DateTime? creationTime;
  final List<Event> _events = <Event>[];

  JournalPage(this.title, this.iconIndex, {this.creationTime}) {
    _id = _idCount;
    updateId();
    creationTime = DateTime.now();
  }

  JournalPage.fromDb(
    int id,
    this.title,
    this.iconIndex,
    this.isPinned,
    this.creationTime,
  ) {
    _id = id;
  }

  JournalPage copyWith({String? title, int? iconIndex}) {
    final copy =
        JournalPage(title ?? this.title, iconIndex ?? this.iconIndex, creationTime: creationTime);
    copy.events.addAll(_events);
    copy.isPinned = isPinned;
    return copy;
  }

  @override
  String toString() {
    return '$title';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'title': title,
      'iconIndex': iconIndex,
      'isPinned': isPinned ? 1 : 0,
      'creationTime': creationTime.toString(),
    };
  }

  void addEvent(Event event) => _events.insert(0, event);

  int? get id => _id;

  int get eventCount => _events.length;

  Event? get lastEvent => eventCount == 0 ? null : _events[0];

  List<Event> get events => _events;
}

class Event {
  static int _idCount = 0;

  static void initCount() async {
    final prefs = await SharedPreferences.getInstance();
    _idCount = prefs.getInt('pageId') ?? 0;
  }

  static void updateId() async {
    final prefs = await SharedPreferences.getInstance();
    _idCount++;
    prefs.setInt('pageId', _idCount);
  }

  int? _id;
  int? _pageId;

  int iconIndex = 0;
  bool isFavourite = false;
  String description;
  DateTime _creationTime = DateTime.now();

  Event(int? pageId, this.description, this.iconIndex) {
    _pageId = pageId;
    _id = _idCount;
    updateId();
    _creationTime = DateTime.now();
  }

  Event.fromDb(
    int id,
    int pageId,
    this.iconIndex,
    this.isFavourite,
    this.description,
    DateTime creationTime,
  ) {
    _id = id;
    _pageId = pageId;
    _creationTime = creationTime;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'pageId': _pageId,
      'iconIndex': iconIndex,
      'isFavourite': isFavourite ? 1 : 0,
      'description': description,
      'creationTime': _creationTime.toString(),
    };
  }

  int? get pageId => _pageId;

  int? get id => _id;

  DateTime get creationTime => _creationTime;
}
