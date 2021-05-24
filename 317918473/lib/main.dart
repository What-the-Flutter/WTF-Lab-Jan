import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'category.dart';
import 'chat.dart';
import 'create_category.dart';
import 'favorites.dart';
import 'settings.dart';
import 'themes/theme.dart';
import 'themes/themes_model.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ChatMessages()),
        ChangeNotifierProvider(create: (context) => CategoryList()),
      ],
      child: ThemeSwitcher(
        initialTheme: MyTheme().light(),
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeChanger.of(context).themeData,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _index = 0;
  final scaffoldState = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldState,
        appBar: MyAppBar(),
        body: Column(
          children: [
            _homeImage(),
            _widgetList(context),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreateCategory(),
              ),
            );
          },
          tooltip: 'Increment',
          child: Icon(Icons.add),
        ),
        bottomNavigationBar: _bottomNavigationBar(context),
      ),
    );
  }

  Padding _homeImage() {
    return Padding(
      padding:
          const EdgeInsets.only(top: 20.0, right: 20, left: 20, bottom: 10),
      child: Stack(
        children: [
          Image.asset('assets/img/Rectangle 23.png'),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 250,
              maxHeight: 200,
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 30.0, left: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Relax Sounds',
                    style: TextStyle(
                        fontFamily: 'Alegreya',
                        fontSize: 28,
                        letterSpacing: 1,
                        wordSpacing: 1,
                        color: Colors.white),
                  ),
                  Text(
                    'Sometimes the most productive thing you can do is relax.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(120, 40),
                      primary: Colors.white,
                      textStyle: TextStyle(fontSize: 16),
                      onPrimary: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {},
                    child: Text(
                      'Play now',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  BottomNavigationBar _bottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _index,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white54,
      elevation: 6,
      onTap: (index) {
        setState(
          () {
            _index = index;
            if (index == 0) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Favorites()));
            }
          },
        );
      },
      items: [
        BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/img/Soundsmusic.svg'), label: ''),
        BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/img/Usr.svg'), label: ''),
      ],
    );
  }

  Expanded _widgetList(BuildContext context) {
    return Expanded(
      child: Consumer<CategoryList>(
        builder: (context, value, child) {
          return value.list.isNotEmpty
              ? ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  children: value.list
                      .map((category) => ListTile(
                            hoverColor: Colors.white10,
                            enabled: true,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 12),
                            leading: Image.asset(category.assetImage),
                            title: Text(
                              category.title,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 22),
                            ),
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => Chat(category: category),
                              ),
                            ),
                            trailing: Visibility(
                              visible: category.isPin,
                              child: Icon(
                                Icons.attach_file,
                                color: Colors.white,
                              ),
                            ),
                            onLongPress: () =>
                                _showBottomSheet(value.list.indexOf(category)),
                            subtitle: Text(
                              category.descripton,
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 16),
                            ),
                          ))
                      .toList(),
                )
              : Center(
                  child: Text('Create some category'),
                );
        },
      ),
    );
  }

  void _showBottomSheet(int index) {
    final _textStyle = TextStyle(
      color: Colors.white,
      fontSize: 20,
    );
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: Icon(
                Icons.info,
                color: Colors.tealAccent,
              ),
              title: Text(
                'Info',
                style: _textStyle,
              ),
              onTap: () => _showDialog(index),
            ),
            ListTile(
              leading: Icon(
                Icons.attach_file,
                color: Colors.greenAccent,
              ),
              title: Text(
                'Pin/Unpin Category',
                style: _textStyle,
              ),
              onTap: () {
                context.read<CategoryList>().pin(index);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.edit,
                color: Colors.blueAccent,
              ),
              title: Text(
                'Edit',
                style: _textStyle,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateCategory(
                      index: index,
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.delete,
                color: Colors.redAccent,
              ),
              title: Text(
                'Delete',
                style: _textStyle,
              ),
              onTap: () {
                context.read<CategoryList>().remove(index);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _showDialog(int index) {
    final category = context.read<CategoryList>().list[index];
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            category.title,
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          content: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(category.assetImage),
              SizedBox(
                width: 20,
              ),
              Text(
                category.descripton,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        );
      },
    );
  }
}

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      title: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: SvgPicture.asset(
          'assets/img/Frame 11.svg',
          alignment: Alignment.bottomCenter,
        ),
      ),
      leading: Padding(
        padding: const EdgeInsets.only(left: 20.0),
        child: IconButton(
          icon: SvgPicture.asset('assets/img/Hamburger.svg'),
          onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => Settings())),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: IconButton(
            icon: Image.asset('assets/img/Ellipse 2.png'),
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(60);
}
