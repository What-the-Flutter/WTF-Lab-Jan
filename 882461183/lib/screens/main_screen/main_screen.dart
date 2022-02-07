import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '/data/repository/chat_repository.dart';
import '/data/repository/event_repository.dart';
import '/data/services/auth.dart';
import '/data/services/firebase_database.dart';
import '/data/services/local_auth.dart';
import '/icons.dart';
import '/models/chat_model.dart';
import '../add_new_chat/add_new_chat.dart';
import '../add_new_chat/add_new_chat_cubit.dart';
import '../chat_screen/chat_screen.dart';
import '../chat_screen/chat_screen_cubit.dart';
import '../settings/settings_cubit.dart';
import 'main_screen_cubit.dart';

Widget startApp() {
  return MultiRepositoryProvider(
    providers: [
      RepositoryProvider<EventRepository>(
        create: (context) => EventRepository(),
      ),
      RepositoryProvider<ChatRepository>(
        create: (context) => ChatRepository(),
      ),
    ],
    child: MultiBlocProvider(
      providers: [
        BlocProvider<MainScreenCubit>(
          create: (context) => MainScreenCubit(),
        ),
        BlocProvider<ChatScreenCubit>(
          create: (context) => ChatScreenCubit(),
        ),
        BlocProvider<AddNewChatCubit>(
          create: (context) => AddNewChatCubit(),
        ),
        BlocProvider<SettingsCubit>(
          create: (context) => SettingsCubit(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return MaterialApp(
          routes: {
            '/add_chat': (context) => const AddNewChat(),
            '/events': (context) => ChatScreen(),
          },
          theme: state.theme,
          title: 'Chat Journal',
          home: MainScreen(),
        );
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _auth = AuthService.instance;
  final _chatRef = FirebaseDatabase.instance.ref().child('Chats/');

  @override
  void initState() {
    super.initState();
    _auth.signInAnon();
    BlocProvider.of<SettingsCubit>(context).initSettings();
    BlocProvider.of<MainScreenCubit>(context).showChats();
    _chatRef.onValue.listen(
      (event) {
        final chatList = <Chat>[];
        final result = event.snapshot.value as Map;
        final list = result.values;
        final finalList = list.toList();
        for (var i = 0; i < finalList.length; i++) {
          final map = Map<String, dynamic>.from(finalList[i]);
          chatList.insert(0, Chat.fromJson(map));
        }
        BlocProvider.of<MainScreenCubit>(context).showChatsFromListen(chatList);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainScreenCubit, MainScreenState>(
      builder: (context, state) {
        return Scaffold(
          drawer: _drawer(),
          appBar: _customAppBar(),
          body: _customListView(state),
          floatingActionButton: _customFloatingActionButton(),
          bottomNavigationBar: _customBottomNavigationBar(state),
        );
      },
    );
  }

  Widget _customFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () async {
        await Navigator.pushNamed(context, '/add_chat');
        BlocProvider.of<MainScreenCubit>(context).showChats();
      },
      tooltip: 'New Page',
      child: const Icon(Icons.add),
      splashColor: Colors.transparent,
    );
  }

  Widget _drawer() {
    return Drawer(
      child: Center(
        child: Column(
          children: [
            const SizedBox(height: 70),
            ElevatedButton(
              onPressed: () async {
                final isAuthenticated = await LocalAuthApi.authenticate();
                if (isAuthenticated) {
                  print('auth');
                } else {
                  print('not auth');
                }
              },
              child: const Text('Face Id'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const AddNewChat(addCategory: true)),
                );
              },
              child: const Text('Add Category'),
            ),
          ],
        ),
      ),
    );
  }

  ListView _customListView(MainScreenState state) {
    BlocProvider.of<MainScreenCubit>(context).sortList(state.chatList);

    return ListView.builder(
      itemCount: state.chatList.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            GestureDetector(
              child: ListTile(
                leading: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      child: Center(
                        child: Icon(
                          iconsData[state.chatList[index].iconIndex],
                          color: const Color.fromRGBO(235, 254, 255, 1),
                          size: 29,
                        ),
                      ),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                    if (state.chatList[index].isPinned)
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
                  state.chatList[index].elementName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(state.chatList[index].elementSubname),
                onTap: () async {
                  final db = FBDatabase();
                  BlocProvider.of<ChatScreenCubit>(context).changeParameters(
                    eventList:
                        await db.fetchEventList(state.chatList[index].id),
                  );
                  final result = await Navigator.pushNamed(
                    context,
                    '/events',
                    arguments: state.chatList[index],
                  ) as String;
                  BlocProvider.of<MainScreenCubit>(context)
                      .newSubname(index, result);
                },
              ),
              onLongPress: () =>
                  _chatOptions(index, state, state.chatList[index]),
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

  void _chatOptions(int index, MainScreenState state, Chat pinnedElement) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 280,
          child: Column(
            children: [
              ListTile(
                onTap: () => _showInfo(context, pinnedElement),
                leading: const Icon(
                  Icons.info,
                  color: Color.fromRGBO(121, 143, 154, 1),
                ),
                title: const Text('Info'),
              ),
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  BlocProvider.of<MainScreenCubit>(context)
                      .pinUnpinChat(pinnedElement);
                },
                leading: const Icon(Icons.attach_file, color: Colors.green),
                title: const Text('Pin/Unpin Page'),
              ),
              ListTile(
                leading: const Icon(Icons.archive, color: Colors.yellow),
                title: const Text('Archive Page'),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.edit, color: Colors.blue),
                title: const Text('Edit Page'),
                onTap: () => _editChat(pinnedElement),
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Delete Page'),
                onTap: () {
                  BlocProvider.of<MainScreenCubit>(context)
                      .removeElement(pinnedElement);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showInfo(context, Chat pinnedElement) {
    Navigator.pop(context);
    final timeFormat = DateFormat('dd/M/y h:mm a');
    final creationDate =
        timeFormat.format(pinnedElement.creationDate).toString();
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
                        iconsData[pinnedElement.iconIndex],
                        color: const Color.fromRGBO(235, 254, 255, 1),
                        size: 29,
                      ),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 20),
                  Text(
                    pinnedElement.elementName,
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
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _editChat(Chat pinnedElement) async {
    Navigator.pop(context);
    await Navigator.of(context).pushNamed(
      '/add_chat',
      arguments: pinnedElement,
    );
    BlocProvider.of<MainScreenCubit>(context).showChats();
  }

  BottomNavigationBar _customBottomNavigationBar(MainScreenState state) {
    return BottomNavigationBar(
      currentIndex: state.selectedTab,
      type: BottomNavigationBarType.fixed,
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
      onTap: (index) =>
          BlocProvider.of<MainScreenCubit>(context).selectTab(index),
    );
  }

  PreferredSizeWidget _customAppBar() {
    return AppBar(
      title: const Center(
        child: Text('Home'),
      ),
      actions: [
        IconButton(
          onPressed: BlocProvider.of<SettingsCubit>(context).changeTheme,
          tooltip: 'Switch Theme',
          icon: const Icon(
            Icons.invert_colors_on,
            color: Color.fromRGBO(235, 254, 255, 1),
            size: 28,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 25),
        )
      ],
    );
  }
}
