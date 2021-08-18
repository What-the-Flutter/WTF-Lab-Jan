// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

List<String> message = <String>['First node', 'Second node', 'Third node '];
List<String> page = <String>['First page', 'Second page', 'Third page'];

class ColorThemeProvider extends StatefulWidget {
  final GlobalKey<ColorThemeProviderState> providerKey;
  final Widget child;

  ColorThemeProvider({required this.providerKey, required this.child}) : super(key: providerKey);

  @override
  ColorThemeProviderState createState() => ColorThemeProviderState();
}

class ColorThemeProviderState extends State<ColorThemeProvider> {
  bool _isDark = false;

  @override
  Widget build(BuildContext context) {
    return _isDark ? _darkTheme : _lightTheme;
  }

  void switchTheme() => setState(() {
        _isDark = !_isDark;
      });

  ColorTheme get _lightTheme => ColorTheme(
        widget.providerKey,
        child: widget.child,
        primaryButtonColor: Colors.black,
        primaryBackgroundColor: Colors.yellow,
        primaryTileColor: Colors.yellow,
        primaryTextColor: Colors.black,
      );

  ColorTheme get _darkTheme => ColorTheme(
        widget.providerKey,
        child: widget.child,
        primaryButtonColor: Colors.white,
        primaryTileColor: Colors.black,
        primaryBackgroundColor: Colors.black,
        primaryTextColor: Colors.white,
      );
}

class ColorTheme extends InheritedWidget {
  final GlobalKey<ColorThemeProviderState> _providerKey;
  final Color primaryBackgroundColor;
  final Color primaryButtonColor;
  final Color primaryTextColor;
  final Color primaryTileColor;
  @override
  final Widget child;

  ColorTheme(
    this._providerKey, {
    required this.primaryButtonColor,
    required this.primaryBackgroundColor,
    required this.primaryTextColor,
    required this.primaryTileColor,
    required this.child,
  }) : super(child: child);

  @override
  bool updateShouldNotify(ColorTheme oldWidget) {
    return true;
  }

  void switchTheme() => _providerKey.currentState!.switchTheme();
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

void _navigateToNextScreen(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute(builder: (context) => NewScreen()),
  );
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<ColorThemeProviderState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ColorThemeProvider(
      providerKey: _key,
      child: const MaterialApp(
        title: 'Flutter',
        home: MainPage(),
      ),
    );
  }

  void _navigateToNextScreen(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => NewScreen()));
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool isOnCreate = false;
  bool isOnEdit = false;
  int index = -1;
  final Set selected = <int>{};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          context.dependOnInheritedWidgetOfExactType<ColorTheme>()?.primaryBackgroundColor,
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.all(8),
              itemCount: page.length,
              separatorBuilder: (_, __) => Container(
                height: 1,
                color: Colors.black,
              ),
              itemBuilder: (context, index) {
                return _PageTile(
                  isSelected: selected.contains(index),
                  key: UniqueKey(),
                  onSelected: () {
                    if (selected.contains(index)) {
                      selected.remove(index);
                    } else {
                      selected.add(index);
                    }
                    setState(() {});
                  },
                  pageText: page[index],
                  onEdit: () {
                    isOnEdit = true;
                    this.index = index;
                    textController.text = page[index];
                    setState(() {

                    });
                  },
                );
              },
            ),
          ),
          if (isOnCreate || isOnEdit)
            TextField(
              controller: textController,
              decoration: InputDecoration(
                hintText: 'Enter a Page Name',
                hintStyle: TextStyle(
                  color: context.dependOnInheritedWidgetOfExactType<ColorTheme>()?.primaryTextColor,
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    if (isOnEdit) {
                      page[index] = textController.text;
                      index = -1;
                      isOnEdit = false;
                    } else {
                      page.add(textController.text);
                    }
                    textController.clear();
                    isOnCreate = false;
                    setState(() {});
                  },
                  icon: Icon(
                    isOnEdit ? Icons.check : Icons.send,
                    color: context
                        .dependOnInheritedWidgetOfExactType<ColorTheme>()
                        ?.primaryButtonColor,
                  ),
                ),
              ),
            )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Business',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.car_rental),
            label: 'Race',
          ),
        ],
        currentIndex: 0,
        selectedItemColor: Colors.amber[800],
        onTap: (_) {},
      ),
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                setState(
                  () {
                    isOnCreate = true;
                  },
                );
              },
              icon: const Icon(
                Icons.add,
              )),
          if (selected.isNotEmpty)
            IconButton(
              onPressed: () {
                for (var i in selected.toList()..sort((a, b) => b.compareTo(a))) {
                  page.removeAt(i);
                }
                print(page);
                selected.clear();
                setState(() {});
              },
              icon: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
            )
        ],
        backgroundColor: Colors.green,
        centerTitle: true,
        title: const Text('Flutter'),
        leading: IconButton(
          icon: const Icon(Icons.wb_sunny),
          onPressed: () {
            context.dependOnInheritedWidgetOfExactType<ColorTheme>()?.switchTheme();
          },
        ),
      ),
    );
  }
}

TextEditingController textController = TextEditingController();

class NewScreen extends StatefulWidget {
  @override
  _NewScreenState createState() => _NewScreenState();
}

class _NewScreenState extends State<NewScreen> {
  bool isOnEdit = false;
  int index = -1;
  final Set selected = <int>{};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          context.dependOnInheritedWidgetOfExactType<ColorTheme>()?.primaryBackgroundColor,
      appBar: AppBar(
        title: const Text('New Screen'),
        actions: [
          if (selected.isNotEmpty)
            IconButton(
              onPressed: () {
                for (var i in selected.toList()..sort((a, b) => b.compareTo(a))) {
                  message.removeAt(i);
                }
                print(message);
                selected.clear();
                setState(() {});
              },
              icon: Icon(
                Icons.delete,
                color: context.dependOnInheritedWidgetOfExactType<ColorTheme>()?.primaryButtonColor,
              ),
            )
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(8),
              itemCount: message.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                return _MessageTile(
                  isSelected: selected.contains(index),
                  key: UniqueKey(),
                  onSelected: () {
                    if (selected.contains(index)) {
                      selected.remove(index);
                    } else {
                      selected.add(index);
                    }
                    setState(() {});
                  },
                  messageText: message[index],
                  onEdit: () {
                    isOnEdit = true;
                    this.index = index;
                    textController.text = message[index];
                  },
                );
              },
            ),
          ),
          TextField(
            controller: textController,
            decoration: InputDecoration(
              hintText: 'Enter a message',
              hintStyle: TextStyle(
                color: context.dependOnInheritedWidgetOfExactType<ColorTheme>()?.primaryTextColor,
              ),
              suffixIcon: IconButton(
                onPressed: () {
                  if (isOnEdit) {
                    message[index] = textController.text;
                    index = -1;
                    isOnEdit = false;
                  } else {
                    message.add(textController.text);
                  }
                  textController.clear();
                  setState(() {});
                },
                icon: Icon(
                  isOnEdit ? Icons.check : Icons.send,
                  color:
                      context.dependOnInheritedWidgetOfExactType<ColorTheme>()?.primaryButtonColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PageTile extends StatefulWidget {
  _PageTile({
    Key? key,
    required this.pageText,
    required this.onEdit,
    required this.onSelected,
    required this.isSelected,
  }) : super(key: key);

  final String pageText;
  final Function() onEdit;
  final Function() onSelected;
  final bool isSelected;

  @override
  __PageTileState createState() => __PageTileState(
        pageText: pageText,
        onEdit: onEdit,
        onSelected: onSelected,
        isSelected: isSelected,
      );
}

class __PageTileState extends State<_PageTile> {
  String pageText;
  Function() onEdit;
  Function() onSelected;
  bool isSelected;

  __PageTileState({
    required this.pageText,
    required this.onEdit,
    required this.onSelected,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        onSelected();
      },
      child: Container(
        color: isSelected
            ? Colors.black.withOpacity(0.05)
            : context.dependOnInheritedWidgetOfExactType<ColorTheme>()?.primaryTileColor,
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: Text(
                pageText,
                style: TextStyle(
                  fontSize: 22,
                  color: context.dependOnInheritedWidgetOfExactType<ColorTheme>()?.primaryTextColor,
                ),
              ),
            ),
            IconButton(
              onPressed: onEdit,
              icon: Icon(
                Icons.edit,
                color: context.dependOnInheritedWidgetOfExactType<ColorTheme>()?.primaryButtonColor,
              ),
            ),
            IconButton(
                onPressed: () {
                  _navigateToNextScreen(context);
                },
                icon: Icon(
                  Icons.arrow_forward_ios,
                  color:
                      context.dependOnInheritedWidgetOfExactType<ColorTheme>()?.primaryButtonColor,
                ))
          ],
        ),
      ),
    );
  }
}

class _MessageTile extends StatefulWidget {
  _MessageTile({
    Key? key,
    required this.messageText,
    required this.onEdit,
    required this.onSelected,
    required this.isSelected,
  }) : super(key: key);

  final String messageText;
  final Function() onEdit;
  final Function() onSelected;
  final bool isSelected;

  @override
  __MessageTileState createState() => __MessageTileState(
        messageText: messageText,
        onEdit: onEdit,
        onSelected: onSelected,
        isSelected: isSelected,
      );
}

class __MessageTileState extends State<_MessageTile> {
  String messageText;
  Function() onEdit;
  Function() onSelected;
  bool isSelected;

  __MessageTileState({
    required this.messageText,
    required this.onEdit,
    required this.onSelected,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        onSelected();
      },
      child: Container(
        color: isSelected
            ? Colors.black.withOpacity(0.05)
            : context.dependOnInheritedWidgetOfExactType<ColorTheme>()?.primaryTileColor,
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: Text(
                messageText,
                style: TextStyle(
                  fontSize: 22,
                  color: context.dependOnInheritedWidgetOfExactType<ColorTheme>()?.primaryTextColor,
                ),
              ),
            ),
            IconButton(
                onPressed: onEdit,
                icon: Icon(
                  Icons.edit,
                  color:
                      context.dependOnInheritedWidgetOfExactType<ColorTheme>()?.primaryButtonColor,
                )),
            IconButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: messageText));
                },
                icon: Icon(
                  Icons.copy,
                  color:
                      context.dependOnInheritedWidgetOfExactType<ColorTheme>()?.primaryButtonColor,
                ))
          ],
        ),
      ),
    );
  }
}
