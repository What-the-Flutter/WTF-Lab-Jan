import 'dart:ui';
import 'package:day_chat/provider/theme_provider.dart';
import 'package:flutter/material.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({Key? key}) : super(key: key);

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final String _message = '';
  String? _userToDo;
  List messages = [];
  final _controller = TextEditingController();

  void clearTextInput() => _controller.clear();

  @override
  void initState() => super.initState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      extendBodyBehindAppBar: true,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/2.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              messageListView(),
              textInput(),
            ],
          ),
        ),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      flexibleSpace: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.transparent.withOpacity(0.3),
              gradient: const LinearGradient(
                colors: [Colors.red, Colors.blue],
              ),
            ),
          ),
        ),
      ),
      title: const Text(
        'Chat Journal',
        style: TextStyle(color: Colors.white),
      ),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      actions: <Widget>[
        IconButton(
          onPressed: () {
            currentTheme.toggleTheme();
          },
          icon: const Icon(Icons.invert_colors_sharp),
        ),
      ],
    );
  }

  Widget messageListView() {
    return Expanded(
      child: ListView.builder(
        itemCount: messages.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: Key(
              messages[index],
            ),
            child: Row(
              mainAxisAlignment: index % 2 == 0 ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.all(9),
                  constraints: const BoxConstraints(maxWidth: 240),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryVariant,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        spreadRadius: 3,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: SelectableText(
                    (messages[index]),
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              ],
            ),
            onDismissed: (direction) => setState(
              () => messages.removeAt(index),
            ),
          );
        },
      ),
    );
  }

  Widget textInput() {
    return Container(
      padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
      height: 75,
      width: double.infinity,
      color: Colors.black.withOpacity(0.4),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                //  color: Colors.grey.withOpacity(0.4),
                color: Theme.of(context).colorScheme.primaryVariant,
              ),
              margin: const EdgeInsets.only(left: 12.0, bottom: 15.0),
              child: Center(
                child: TextField(
                  keyboardType: TextInputType.text,
                  cursorColor: Colors.white,
                  style: const TextStyle(color: Colors.white, fontSize: 17),
                  textInputAction: TextInputAction.done,
                  controller: _controller,
                  textCapitalization: TextCapitalization.sentences,
                  autocorrect: true,
                  enableSuggestions: true,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(top: 5),
                    border: InputBorder.none,
                    prefixIcon: IconButton(
                      icon: const Icon(Icons.add, color: Colors.white, size: 22),
                      onPressed: () {},
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          GestureDetector(
            onTap: () => setState(
              () {
                _controller.text.isEmpty ? TextInputAction.continueAction : messages.add(_controller.text);
                clearTextInput();
              },
            ),
            child: Container(
              margin: const EdgeInsets.only(right: 15.0, bottom: 12.0),
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                //color: Colors.grey.withOpacity(0.4),
                color: Theme.of(context).colorScheme.primaryVariant,
                borderRadius: BorderRadius.circular(40),
              ),
              child: const Icon(Icons.send, color: Colors.white, size: 18),
            ),
          ),
        ],
      ),
    );
  }
}
