import 'package:flutter/material.dart';

import '../../../../domain/entities/event_info.dart';
import '../../../navigator/router.dart';
import '../../../res/styles.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isDarkMode = false;

  /// need for save  current event
  int _currentEventIndex = -1;

  final List<EventInfo> _events = [
    EventInfo(
      title: 'Journal',
      icon: const Icon(Icons.collections_bookmark),
    ),
    EventInfo(
      title: 'Notes',
      icon: const Icon(Icons.menu_book_outlined),
    ),
    EventInfo(
      icon: const Icon(Icons.thumb_up_alt_outlined),
      title: 'Gratitude',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _body(),
      drawer: const Drawer(),
      floatingActionButton: _floatingActionButton(),
      bottomNavigationBar: _bottomNavigationBar(),
    );
  }

  Widget _body() {
    final _elements = <Widget>[
      const QuestionBotButton(),
      ..._events.map((e) => ListTile(
            title: Text(e.title),
            leading: CircleIcon(icon: e.icon),
            subtitle: Text(e.lastMessage),
          )),
    ];
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: ListView.separated(
        separatorBuilder: (context, index) => const Divider(),
        itemCount: _elements.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              if (_elements[index] is ListTile || (_elements[index]is QuestionBotButton)) {
                Navigator.of(context).pushNamed(Routs.event, arguments: _events[index-1].title);
              }
            },
            onLongPress: () {
              _currentEventIndex = index;
              _showBottomSheetDialog(context);
            },
            child: _elements[index],
          );
        },
      ),
    );
  }

  Future<dynamic> _showBottomSheetDialog(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: <Widget>[
            ListTile(
              onTap: _showPageInfo,
              leading: Icon(
                Icons.info,
                color: Theme.of(context).primaryColor,
              ),
              title: const Text('Info'),
            ),
            ListTile(
              onTap: _pinPage,
              leading: Icon(
                Icons.attach_file,
                color: Colors.green[500],
              ),
              title: const Text('Pin/Unpin page'),
            ),
            ListTile(
              onTap: _editPage,
              leading: const Icon(
                Icons.edit,
                color: Colors.blue,
              ),
              title: const Text('Edit Page'),
            ),
            ListTile(
              onTap: _deletePage,
              leading: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
              title: const Text('Delete Page'),
            ),
          ],
        );
      },
    );
  }

  void _deletePage() {
    setState(() {
      _events.removeAt(_currentEventIndex-1);
    });
    Navigator.of(context).pop();
  }

  void _editPage() async {
    final event = await Navigator.of(context).popAndPushNamed(
      Routs.createEvent,
      arguments: _events[_currentEventIndex-1],
    );
    if (event is EventInfo) {
      setState(() {
        _events[_currentEventIndex] = event;
      });
    }
  }

  void _pinPage() {
    if (_events.elementAt(_currentEventIndex).isPinned) {
      var index = 0;
      while (index < _events.length && _events[index-1].isPinned) {
        index++;
      }
      setState(() {
        _events.elementAt(_currentEventIndex).isPinned ^= true;
        _events.insert(index - 1, _events.removeAt(_currentEventIndex));
      });
    } else {
      setState(() {
        _events.insert(0, _events.removeAt(_currentEventIndex));
        _events.first.isPinned = true;
      });
    }
    Navigator.of(context).pop();
  }

  void _showPageInfo() {
    Navigator.of(context).pop();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: CircleAvatar(
                  child: _events[_currentEventIndex-1].icon,
                  radius: 32,
                  backgroundColor: Theme.of(context).cardColor,
                ),
                title: Text(
                  _events[_currentEventIndex-1].title,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Created'),
                    Text(_events[_currentEventIndex-1].createDate),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 17),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Latest Event'),
                    Text(_events[_currentEventIndex-1].lastEditDate),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: ElevatedButton(
                child: Text(
                  'OK',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyText1!.color,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).scaffoldBackgroundColor,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        );
      },
    );
  }

  BottomNavigationBar _bottomNavigationBar() {
    return BottomNavigationBar(
      showSelectedLabels: true,
      showUnselectedLabels: true,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.note), label: 'Daily'),
        BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Timeline'),
        BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
      ],
    );
  }

  FloatingActionButton _floatingActionButton() {
    return FloatingActionButton(
      elevation: 8,
      backgroundColor: Colors.yellow,
      foregroundColor: Colors.black,
      onPressed: () {
        _createPage(context);
      },
      child: const Icon(Icons.add),
    );
  }

  AppBar _appBar() {
    return AppBar(
      actions: [
        IconButton(
          icon: _isDarkMode
              ? const Icon(Icons.invert_colors)
              : const Icon(Icons.invert_colors_outlined),
          onPressed: _changeTheme,
        ),
      ],
      centerTitle: true,
      title: const Text('Home'),
    );
  }

  Future<void> _createPage(BuildContext context) async {
    final newPage = await Navigator.of(context).pushNamed(Routs.createEvent);
    if (newPage is EventInfo) {
      setState(() {
        _events.add(newPage);
      });
    }
  }

  void _changeTheme() {
    setState(() {
      InheritedCustomTheme.of(context).changeTheme();
      _isDarkMode ^= true;
    });
  }
}

class CircleIcon extends StatelessWidget {
  const CircleIcon({
    Key? key,
    required this.icon,
  }) : super(key: key);

  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey,
      ),
      child: icon,
    );
  }
}

class QuestionBotButton extends StatelessWidget {
  const QuestionBotButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.lightGreen,
          borderRadius: BorderRadius.all(Radius.circular(6)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(
                Icons.ac_unit,
                size: 32,
              ),
              SizedBox(width: 16),
              Text(
                'Questionnaire Bot',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
