import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '/data/services/auth.dart';
import '/icons.dart';
import '/models/chat_model.dart';
import '/screens/main_screen/main_screen_cubit.dart';
import '../add_new_chat/add_new_chat.dart';
import '../settings/settings_cubit.dart';
import 'chat_screen_cubit.dart';

class ChatScreen extends StatefulWidget {
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = AuthService.instance;
  final _chatRef = FirebaseDatabase.instance.ref().child('Chats/');

  @override
  void initState() {
    super.initState();
    _auth.signInAnon();
    BlocProvider.of<SettingsCubit>(context).initSettings();
    BlocProvider.of<ChatScreenCubit>(context).initCubit(_chatRef);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatScreenCubit, ChatScreenState>(
      builder: (context, state) {
        return Scaffold(
          drawer: _drawer(BlocProvider.of<SettingsCubit>(context).state),
          appBar: _customAppBar(),
          body: _customListView(state),
          floatingActionButton: _customFloatingActionButton(),
          bottomNavigationBar: _customBottomNavigationBar(),
        );
      },
    );
  }

  Widget _customFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () async {
        await Navigator.pushNamed(context, '/add_chat');
        BlocProvider.of<ChatScreenCubit>(context).showChats();
      },
      tooltip: 'New Page',
      child: const Icon(Icons.add),
      splashColor: Colors.transparent,
    );
  }

  Widget _drawer(SettingsState state) {
    return Drawer(
      child: Center(
        child: Column(
          children: [
            const SizedBox(height: 70),
            _drawerButton(
              BlocProvider.of<SettingsCubit>(context).share,
              'Help spread the word',
              state,
            ),
            const SizedBox(height: 20),
            _drawerButton(
              () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddNewChat(addCategory: true),
                  ),
                );
              },
              'Add Category',
              state,
            ),
            const SizedBox(height: 20),
            _drawerButton(
              BlocProvider.of<SettingsCubit>(context).changeBubbleChatSide,
              'Change Chat Side',
              state,
            ),
            const SizedBox(height: 20),
            _drawerButton(
              BlocProvider.of<SettingsCubit>(context).changeDateAlign,
              'Change Date Align',
              state,
            ),
            const SizedBox(height: 20),
            _drawerButton(
              BlocProvider.of<SettingsCubit>(context).addBGImage,
              'Change Chat Background Image',
              state,
            ),
            const SizedBox(height: 20),
            _drawerButton(
              BlocProvider.of<SettingsCubit>(context).resetBGImage,
              'Delete Chat Background Image',
              state,
            ),
            const SizedBox(height: 20),
            _drawerDropdownButton(state),
            const Spacer(),
            _drawerButton(
              BlocProvider.of<SettingsCubit>(context).resetSettings,
              'Reset Settings',
              state,
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _drawerDropdownButton(SettingsState state) {
    final textStyle = TextStyle(fontSize: state.fontSize, color: Colors.yellow);

    return DropdownButton(
      hint: AnimatedDefaultTextStyle(
        duration: const Duration(milliseconds: 250),
        style: textStyle,
        child: Text(state.fontSizeString),
      ),
      items: ['Small', 'Medium', 'Large'].map(buildMenuItem).toList(),
      onChanged: (size) {
        setState(() {});
        BlocProvider.of<SettingsCubit>(context).changeFontSize(size.toString());
      },
    );
  }

  Widget _drawerButton(Function onPressed, String text, SettingsState state) {
    final textStyle = TextStyle(fontSize: state.fontSize, color: Colors.yellow);

    return ElevatedButton(
      onPressed: () => onPressed(),
      child: AnimatedDefaultTextStyle(
        style: textStyle,
        duration: const Duration(milliseconds: 250),
        child: Text(text),
      ),
    );
  }

  DropdownMenuItem<String> buildMenuItem(String item) {
    return DropdownMenuItem(
      value: item,
      child: Text(
        item,
        style: TextStyle(
          fontSize: BlocProvider.of<SettingsCubit>(context).state.fontSize,
        ),
      ),
    );
  }

  ListView _customListView(ChatScreenState state) {
    BlocProvider.of<ChatScreenCubit>(context).sortList(state.chatList);

    return ListView.builder(
      itemCount: state.chatList.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            GestureDetector(
              child: ListTile(
                leading: _chatAvatar(state, index),
                title: Text(
                  state.chatList[index].elementName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize:
                        BlocProvider.of<SettingsCubit>(context).state.fontSize,
                  ),
                ),
                subtitle: Text(
                  state.chatList[index].elementSubname,
                  style: TextStyle(
                      fontSize: BlocProvider.of<SettingsCubit>(context)
                          .state
                          .fontSize),
                ),
                onTap: () => _onTap(state, index),
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

  Widget _chatAvatar(ChatScreenState state, int index) {
    return Stack(
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
    );
  }

  void _onTap(ChatScreenState state, int index) async {
    final result = await Navigator.pushNamed(
      context,
      '/events',
      arguments: state.chatList[index],
    ) as String;
    BlocProvider.of<ChatScreenCubit>(context).newSubname(index, result);
  }

  void _chatOptions(int index, ChatScreenState state, Chat pinnedElement) {
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
                title: Text(
                  'Info',
                  style: TextStyle(
                    fontSize:
                        BlocProvider.of<SettingsCubit>(context).state.fontSize,
                  ),
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  BlocProvider.of<ChatScreenCubit>(context)
                      .pinUnpinChat(pinnedElement);
                },
                leading: const Icon(Icons.attach_file, color: Colors.green),
                title: Text(
                  'Pin/Unpin Page',
                  style: TextStyle(
                    fontSize:
                        BlocProvider.of<SettingsCubit>(context).state.fontSize,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.archive, color: Colors.yellow),
                title: Text(
                  'Archive Page',
                  style: TextStyle(
                    fontSize:
                        BlocProvider.of<SettingsCubit>(context).state.fontSize,
                  ),
                ),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.edit, color: Colors.blue),
                title: Text(
                  'Edit Page',
                  style: TextStyle(
                    fontSize:
                        BlocProvider.of<SettingsCubit>(context).state.fontSize,
                  ),
                ),
                onTap: () => _editChat(pinnedElement),
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: Text(
                  'Delete Page',
                  style: TextStyle(
                    fontSize:
                        BlocProvider.of<SettingsCubit>(context).state.fontSize,
                  ),
                ),
                onTap: () {
                  BlocProvider.of<ChatScreenCubit>(context)
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
                    style: TextStyle(
                        fontSize: BlocProvider.of<SettingsCubit>(context)
                            .state
                            .fontSize),
                  ),
                ],
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Created:',
                    style: TextStyle(
                        fontSize: BlocProvider.of<SettingsCubit>(context)
                            .state
                            .fontSize),
                  ),
                  Text(
                    creationDate,
                    style: TextStyle(
                        fontSize: BlocProvider.of<SettingsCubit>(context)
                            .state
                            .fontSize),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Last event:',
                    style: TextStyle(
                        fontSize: BlocProvider.of<SettingsCubit>(context)
                            .state
                            .fontSize),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'OK',
                    style: TextStyle(
                        fontSize: BlocProvider.of<SettingsCubit>(context)
                            .state
                            .fontSize),
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
    BlocProvider.of<ChatScreenCubit>(context).showChats();
  }

  BottomNavigationBar _customBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: BlocProvider.of<MainScreenCubit>(context).state.selectedTab,
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
      centerTitle: true,
      title: Text(
        'Home',
        style: TextStyle(
            fontSize: BlocProvider.of<SettingsCubit>(context).state.fontSize),
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
