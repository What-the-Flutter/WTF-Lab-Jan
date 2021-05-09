import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Color(0xff253334),
          colorScheme: ColorScheme.light(),
          fontFamily: 'AlegreyaSans'),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _index;

  @override
  void initState() {
    super.initState();
    _index = 0;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Color(0xff253334),
          title: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: SvgPicture.asset(
              'assets/img/Frame 11.svg',
              alignment: Alignment.bottomCenter,
            ),
          ),
          //centerTitle: true,
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
        ),
        body: Container(
          child: Column(
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
                            color: Color(0xff253334),
                            child: ListTile(
                              hoverColor: Colors.white10,
                              enabled: true,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 12),
                              leading: Image.asset(category.assetImage),
                              title: Text(
                                category.title,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 22),
                              ),
                              onTap: () {},
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
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: null,
          tooltip: 'Increment',
          child: Icon(Icons.add),
        ),
        bottomNavigationBar: Theme(
          data: ThemeData(primaryColor: Color(0xff253334)),
          child: BottomNavigationBar(
            currentIndex: _index,
            backgroundColor: Color(0xff253334),
            showSelectedLabels: false,
            showUnselectedLabels: false,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white54,
            elevation: 6,
            onTap: (index) => setState(() {
              _index = index;
              print(_index);
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

class Category {
  final String assetImage;
  final String descripton;
  final String title;

  Category(this.assetImage, this.descripton, this.title);

  static final list = [
    Category(
        'assets/img/Rectangle 231.png', 'descrtiption about forest', 'Forest'),
    Category(
        'assets/img/Rectangle 252.png', 'descrtiption about forest', 'Forest'),
    Category(
        'assets/img/Rectangle 263.png', 'descrtiption about forest', 'Forest'),
    Category(
        'assets/img/Rectangle 284.png', 'descrtiption about forest', 'Forest'),
    Category(
        'assets/img/Rectangle 231.png', 'descrtiption about forest', 'Forest'),
    Category(
        'assets/img/Rectangle 252.png', 'descrtiption about forest', 'Forest'),
    Category(
        'assets/img/Rectangle 263.png', 'descrtiption about forest', 'Forest'),
    Category(
        'assets/img/Rectangle 284.png', 'descrtiption about forest', 'Forest'),
  ];
}
