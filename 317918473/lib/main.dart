import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'category.dart';
import 'chat.dart';
import 'favorites.dart';

const backgroundColor = Color(0xff253334);

void main() {
  runApp(ChangeNotifierProvider(
      create: (context) => ChatMessages(), child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: backgroundColor,
          colorScheme: ColorScheme.light(),
          fontFamily: 'AlegreyaSans'),
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: 20.0, right: 20, left: 20, bottom: 10),
              child: Stack(
                //alignment: AlignmentDirectional.topStart,
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
                          SizedBox(height: 10),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(120, 40),
                                primary: Colors.white,
                                textStyle: TextStyle(fontSize: 16),
                                onPrimary: Colors.black,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                              onPressed: () {},
                              child: Text(
                                'Play now',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ))
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                children: Category.list
                    .map((category) => Material(
                          color: backgroundColor,
                          child: ListTile(
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
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          Chat(category: category)));
                            },
                            subtitle: Text(
                              category.descripton,
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 16),
                            ),
                          ),
                        ))
                    .toList(),
              ),
            )
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: null,
          tooltip: 'Increment',
          child: Icon(Icons.add),
        ),
        bottomNavigationBar: Theme(
          data: ThemeData(primaryColor: backgroundColor),
          child: BottomNavigationBar(
            currentIndex: _index,
            backgroundColor: backgroundColor,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white54,
            elevation: 6,
            onTap: (index) => setState(() {
              _index = index;
              if (index == 0) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Favorites()));
              }
            }),
            items: [
              BottomNavigationBarItem(
                  icon: SvgPicture.asset('assets/img/Soundsmusic.svg'),
                  label: ''),
              BottomNavigationBarItem(
                  icon: SvgPicture.asset('assets/img/Usr.svg'), label: ''),
            ],
          ),
        ),
      ),
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
      backgroundColor: Color(0xff253334),
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
          onPressed: () {},
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: IconButton(
            icon: Image.asset('assets/img/Ellipse 2.png'),
            onPressed: () {},
          ),
        )
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(60);
}
