import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

//import '/chat_bot_element.dart';
import '/models/chat_model.dart';
import '/theme/custom_theme.dart';
import '/theme/theme_color.dart';
import '../add_new_chat/add_new_chat.dart';
import '../add_new_chat/add_new_chat_cubit.dart';
import '../chat_screen/chat_screen.dart';
import '../chat_screen/chat_screen_cubit.dart';
import 'main_screen_cubit.dart';

Widget startApp() {
  return CustomTheme(
    themeData: lightTheme,
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
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/add_chat': (context) => const AddNewChat(),
        '/events': (context) => ChatScreen(),
      },
      theme: CustomTheme.of(context),
      title: 'Chat Journal',
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainScreenCubit, MainScreenState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: _customAppBar(),
          body: StreamBuilder(
            builder: (context, projectsnap) {
              return _customListView(state);
            },
            stream: BlocProvider.of<MainScreenCubit>(context).showChats(),
          ),
          floatingActionButton: _customFloatingActionButton(),
          bottomNavigationBar: _customBottomNavigationBar(state),
        );
      },
    );
  }

  Widget _customFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () async =>
          await Navigator.pushNamed(context, '/add_chat') as Chat?,
      tooltip: 'New Page',
      child: const Icon(Icons.add),
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      foregroundColor: Colors.black,
      splashColor: Colors.transparent,
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
                          state.chatList[index].icon,
                          color: Theme.of(context).colorScheme.surface,
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
      backgroundColor: Theme.of(context).colorScheme.background,
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
                title: Text(
                  'Info',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  BlocProvider.of<MainScreenCubit>(context)
                      .pinUnpinChat(pinnedElement);
                },
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
                onTap: () => _editChat(pinnedElement),
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: Text(
                  'Delete Page',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                ),
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
                        pinnedElement.icon,
                        color: Theme.of(context).colorScheme.surface,
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

  void _editChat(Chat pinnedElement) async {
    Navigator.pop(context);
    await Navigator.of(context).pushNamed(
      '/add_chat',
      arguments: pinnedElement,
    );
  }

  BottomNavigationBar _customBottomNavigationBar(MainScreenState state) {
    return BottomNavigationBar(
      currentIndex: state.selectedTab,
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
      onTap: (index) =>
          BlocProvider.of<MainScreenCubit>(context).selectTab(index),
    );
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
