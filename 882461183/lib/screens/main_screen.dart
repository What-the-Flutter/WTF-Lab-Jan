import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

//import '/chat_bot_element.dart';
import '/models/chat_model.dart';
import '/screens/add_new_chat.dart';
import '/theme/custom_theme.dart';
import 'chat_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Chat> pinnedList = [];
  int _selectedTab = 0;
  int _pinnedCount = 0;
  List<Chat> chatList = [
    Chat(
      icon: Icons.flight_takeoff,
      elementName: 'Travel',
      creationDate: DateTime.now(),
      key: UniqueKey(),
    ),
    Chat(
      icon: Icons.weekend,
      elementName: 'Family',
      creationDate: DateTime.now(),
      key: UniqueKey(),
    ),
    Chat(
      icon: Icons.fitness_center,
      elementName: 'Sports',
      creationDate: DateTime.now(),
      key: UniqueKey(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: _customAppBar(),
      body: _customListView(),
      floatingActionButton: _customFloatingActionButton(),
      bottomNavigationBar: _customBottomNavigationBar(),
    );
  }

  Widget _customFloatingActionButton() {
    return FloatingActionButton(
      onPressed: _addNewChat,
      tooltip: 'New Page',
      child: const Icon(Icons.add),
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      foregroundColor: Colors.black,
      splashColor: Colors.transparent,
    );
  }

  void _addNewChat() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddNewChat(),
      ),
    );
    if (result is Chat) {
      chatList.insert(0, result);
      setState(() {});
    }
  }

  ListView _customListView() {
    final timeFormat = DateFormat('dd/M/y');
    if (_pinnedCount > 0) {
      pinnedList = chatList.where((element) => element.isPinned).toList();
      for (var element in chatList) {
        if (!element.isPinned) {
          pinnedList.add(element);
        }
      }
    } else {
      pinnedList = chatList;
    }

    return ListView.builder(
      itemCount: pinnedList.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            GestureDetector(
              child: ListTile(
                dense: false,
                trailing: pinnedList[index].eventList.isEmpty
                    ? Container(height: 0, width: 0)
                    : Text(
                        timeFormat
                            .format(pinnedList[index].eventList[0].date)
                            .toString(),
                      ),
                leading: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      child: Center(
                        child: Icon(
                          pinnedList[index].icon,
                          color: Theme.of(context).colorScheme.surface,
                          size: 29,
                        ),
                      ),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                    if (pinnedList[index].isPinned)
                      CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: 7,
                        child: Icon(
                          Icons.push_pin,
                          color: Theme.of(context).colorScheme.onSecondary,
                          size: 13,
                        ),
                      ),
                  ],
                ),
                title: Text(
                  pinnedList[index].elementName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(pinnedList[index].elementSubname),
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(pinnedList[index]),
                    ),
                  );
                  setState(() {});
                },
              ),
              onLongPress: () => _chatOptions(index),
            ),
            const Divider(
              height: 18,
              thickness: 1,
            ),
          ],
        );
      },
    );
  }

  void _chatOptions(int index) {
    showModalBottomSheet(
      backgroundColor: Theme.of(context).colorScheme.background,
      context: context,
      builder: (context) {
        return Container(
          height: 280,
          child: Column(
            children: [
              ListTile(
                onTap: () => _showInfo(context, index),
                leading: const Icon(
                  Icons.info,
                  color: Color.fromRGBO(121, 143, 154, 1),
                ),
                title: Text(
                  'Info',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                ),
              ),
              ListTile(
                onTap: () => _pinUnpinChat(index),
                leading: const Icon(Icons.attach_file, color: Colors.green),
                title: Text(
                  'Pin/Unpin Page',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.archive, color: Colors.yellow),
                title: Text(
                  'Archive Page',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.edit, color: Colors.blue),
                title: Text(
                  'Edit Page',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                ),
                onTap: () => _editChat(index),
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: Text(
                  'Delete Page',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                ),
                onTap: () {
                  for (var element in chatList) {
                    if (element.key == pinnedList[index].key) {
                      chatList.remove(element);
                      break;
                    }
                  }
                  Navigator.pop(context);
                  setState(() {});
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _pinUnpinChat(int index) {
    Navigator.pop(context);
    pinnedList[index].isPinned = !pinnedList[index].isPinned;
    if (pinnedList[index].isPinned) {
      _pinnedCount++;
    } else {
      _pinnedCount--;
    }
    setState(() {});
  }

  void _showInfo(context, int index) {
    Navigator.pop(context);
    final timeFormat = DateFormat('dd/M/y h:mm a');
    final creationDate =
        timeFormat.format(pinnedList[index].creationDate).toString();
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: Container(
            height: 350,
            child: AlertDialog(
              title: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    child: Center(
                      child: Icon(
                        pinnedList[index].icon,
                        color: Theme.of(context).colorScheme.surface,
                        size: 29,
                      ),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 20),
                  Text(
                    pinnedList[index].elementName,
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Created:'),
                  Text(creationDate),
                  const SizedBox(height: 20),
                  const Text('Last event:'),
                  pinnedList[index].eventList.isNotEmpty
                      ? Text(timeFormat
                          .format(pinnedList[index].eventList[0].date)
                          .toString())
                      : const Text('No events yet'),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'OK',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _editChat(int index) async {
    Navigator.pop(context);
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddNewChat(
          isEditing: true,
          editingChat: pinnedList[index],
        ),
      ),
    );
    if (result is Chat) {
      pinnedList[index] = result;
      for (var element in chatList) {
        if (element.key == pinnedList[index].key) {
          element = pinnedList[index];
          break;
        }
      }
      setState(() {});
    }
  }

  BottomNavigationBar _customBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _selectedTab,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Theme.of(context).colorScheme.background,
      unselectedItemColor: Theme.of(context).colorScheme.onSecondary,
      selectedItemColor: Theme.of(context).colorScheme.onBackground,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.book),
          label: 'Home',
          tooltip: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.assignment_rounded),
          label: 'Daily',
          tooltip: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          label: 'Timeline',
          tooltip: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.explore),
          label: 'Explore',
          tooltip: '',
        ),
      ],
      onTap: _onSelectTab,
    );
  }

  void _onSelectTab(int index) {
    if (_selectedTab == index) return;
    setState(() {
      _selectedTab = index;
    });
  }

  PreferredSizeWidget _customAppBar() {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Theme.of(context).colorScheme.surface,
      leading: IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () {},
      ),
      title: const Center(
        child: Text('Home'),
      ),
      actions: [
        IconButton(
          onPressed: CustomTheme.instanceOf(context).changeTheme,
          tooltip: 'Switch Theme',
          icon: Icon(
            Icons.invert_colors_on,
            color: Theme.of(context).colorScheme.surface,
            size: 28,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 25),
        )
      ],
    );
  }
}
