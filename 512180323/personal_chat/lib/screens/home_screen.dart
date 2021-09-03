import 'package:flutter/material.dart';

import '../constants.dart';
import '../custom_theme.dart';
import '../widgets/home_screen_widgets/item_home_screen.dart';
import 'add_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool pin = false;
  bool themeChange = false;
  CustomThemeKeys themeKey;

  void _changeTheme(BuildContext buildContext, CustomThemeKeys key) {
    CustomTheme.instanceOf(buildContext).changeTheme(key);
  }

  List<MyItem> pageEvent = <MyItem>[
    const MyItem(
      title: 'Fly',
      icon: Icons.airplanemode_on_sharp,
    ),
    const MyItem(
      title: 'Travel',
      icon: Icons.directions_car,
    ),
    const MyItem(
      title: 'Hobie',
      icon: Icons.directions_car,
    ),
  ];

  // Method for more functionalities with page
  void _moreFunctionsWithPage(int index) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(
                Icons.push_pin_outlined,
                color: Colors.red,
              ),
              title: const Text('Pin/Unpin'),
              onTap: () {
                pageEvent.insert(0, pageEvent[index]);
                pageEvent.removeAt(index + 1);
                setState(() => pin = true);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.edit,
                color: Colors.red,
              ),
              title: const Text('Edit'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
              title: const Text('Delete'),
              onTap: () {
                pageEvent.removeAt(index);
                setState(() {});
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.info_outline,
                color: Colors.red,
              ),
              title: const Text('Get info'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    content: Container(
                      height: 150,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: blue,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Icon(pageEvent[index].icon),
                                padding: const EdgeInsets.all(10.0),
                              ),
                              Text(
                                pageEvent[index].title,
                                style: const TextStyle(fontSize: 18.0),
                              ),
                            ],
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          ),
                          Container(
                            margin: const EdgeInsets.all(10),
                            height: 1,
                            color: Colors.red,
                          ),
                          const Text(
                            'Created:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text('Today at 12:07 AM'),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Ok.'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).backgroundColor,
        leading: Container(
          margin: const EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              const BoxShadow(
                blurRadius: 1,
                color: shadowColor,
                offset: Offset(2, 2),
              ),
            ],
          ),
          child: IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.menu,
              color: Theme.of(context).accentColor,
            ),
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                const BoxShadow(
                  blurRadius: 1,
                  color: shadowColor,
                  offset: Offset(-2, 2),
                ),
              ],
            ),
            child: IconButton(
              onPressed: () {
                themeChange = !themeChange;
                if (themeChange == true) {
                  themeKey = CustomThemeKeys.light;
                } else {
                  themeKey = CustomThemeKeys.dark;
                }

                _changeTheme(context, themeKey);
              },
              icon: themeChange
                  ? const Icon(
                      Icons.wb_incandescent,
                      color: themeIconLight,
                      size: 30,
                    )
                  : const Icon(
                      Icons.wb_incandescent_outlined,
                      color: themeIconDark,
                      size: 30,
                    ),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: pageEvent.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onLongPress: () {
              _moreFunctionsWithPage(index);
            },
            child: pageEvent[index],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (builder) => AddScreen(),
            ),
          );
        },
        backgroundColor: Theme.of(context).accentColor,
        child: const Icon(
          Icons.add,
          color: black,
        ),
      ),
    );
  }
}
