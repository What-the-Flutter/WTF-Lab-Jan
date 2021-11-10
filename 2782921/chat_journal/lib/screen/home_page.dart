import 'package:chat_journal/components/icons.dart';
import 'package:flutter/material.dart';
import '../navigation/fluro_router.dart';
import 'appbar.dart';
import 'bottom_nv_bar.dart';
import 'consts.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<ListviewItems> title_lists = [
    ListviewItems(
      title: 'Travel',
      icon: const Icon(
        Icons.card_travel,
        size: 40,
      ),
    ),
    ListviewItems(
      title: 'Family',
      icon: const Icon(
        Icons.living_rounded,
        size: 40,
      ),
    ),
    ListviewItems(
      title: 'Sports',
      icon: const Icon(
        Icons.sports_mma,
        size: 40,
      ),
    ),
  ];
  late final ListviewItems _selected;

  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimilarScreenTop(title: 'Home'),
      drawer: const Drawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: GestureDetector(
              onTap: () {
                print('Qustionary tapped');
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.indigo,
                  borderRadius: BorderRadius.circular(10),
                ),
                width: 350,
                height: 40,
                child: const Align(
                  child: Text(
                    'Questionary Bot',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: title_lists.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onLongPress: () {
                    CustomModalBottomSheet(context, index);
                  },
                  child: title_lists[index],
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _create(context);
        },
        tooltip: 'add a title',
        child: const Icon(
          Icons.add,
          size: 30,
        ),
      ),
      bottomNavigationBar: BottomNavigationBarCustom(),
    );
  }

  Future<dynamic> CustomModalBottomSheet(BuildContext context, int index) {
    _printInfo(BuildContext context) async {
      final select = await showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            children: [
              Expanded(
                child: title_lists[index],
              ),
            ],
          );
        },
      );
      return Navigator.pop(context);
    }

    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(
                Icons.info,
              ),
              title: const Text('Info'),
              onTap: () {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return Container(
                      width: 200,
                      height: 200,
                      child: SimpleDialog(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              title_lists[index].icon,
                              Text(
                                title_lists[index].title,
                                style: TextStyle(fontSize: 30),
                              ),
                            ],
                          ),
                          const Center(
                            child: Text(
                              'Information about creation of 19:45',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.indigo),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.cancel),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          )
                        ],
                        elevation: 10,
                        backgroundColor: Colors.white,
                      ),
                    );
                  },
                );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.push_pin,
                color: Colors.green,
              ),
              title: const Text('Pin/Unpin Page'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.move_to_inbox_outlined,
                color: Colors.yellow,
              ),
              title: const Text('Archive page'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.edit_outlined,
                color: Colors.blue,
              ),
              title: const Text('Edit'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.delete_outlined,
                color: Colors.red,
              ),
              title: const Text('Delete'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _create(BuildContext context) async {
    final nameController = TextEditingController();
    late String titleName;
    late Icon icon;
    const systemIcons = <Icon>[
      Icon(
        Icons.work,
        size: 40,
      ),
      Icon(
        Icons.account_balance,
        size: 40,
      ),
      Icon(
        Icons.perm_identity,
        size: 40,
      ),
      Icon(
        Icons.account_balance_wallet,
        size: 40,
      ),
      Icon(
        Icons.add_shopping_cart,
        size: 40,
      ),
      Icon(
        Icons.pets,
        size: 40,
      ),
      Icon(
        Icons.thumb_up_off_alt,
        size: 40,
      ),
      Icon(
        Icons.android,
        size: 40,
      ),
      Icon(
        Icons.gavel,
        size: 40,
      ),
      Icon(
        Icons.support,
        size: 40,
      ),
      Icon(
        Icons.accessibility_new,
        size: 40,
      ),
      Icon(
        Icons.settings_phone,
        size: 40,
      ),
      Icon(
        Icons.g_translate,
        size: 40,
      ),
      Icon(
        Icons.thumb_down_off_alt,
        size: 40,
      ),
      Icon(
        Icons.flight_land,
        size: 40,
      ),
      Icon(
        Icons.view_sidebar,
        size: 40,
      ),
      Icon(
        Icons.settings_power,
        size: 40,
      ),
      Icon(
        Icons.mail,
        size: 40,
      ),
      Icon(
        Icons.outlined_flag,
        size: 40,
      ),
      Icon(
        Icons.construction,
        size: 40,
      ),
    ];
    var _iconsize = 40.0;
    _selected = await showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Center(child: Text('Edit the text')),
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: nameController,
                    onChanged: (value) {
                      titleName = value;
                    },
                    decoration: kTextFieldDecoration,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(
                      () {
                        nameController.clear;
                        title_lists.add(
                          ListviewItems(
                            title: '$titleName',
                            icon: icon,
                          ),
                        );

                        Navigator.pop(context);
                      },
                    );
                  },
                  icon: const Icon(
                    Icons.done,
                    color: Colors.indigo,
                  ),
                ),
              ],
            ),
            Container(
              height: 350.0, // Change as per your requirement
              width: 150.0,
              child: GridView.builder(
                itemCount: systemIcons.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4),
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: GridTile(
                      child: IconButton(
                        icon: systemIcons[index],
                        iconSize: _iconsize,
                        onPressed: () {
                          setState(() {
                            icon = systemIcons[index];
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
          elevation: 10,
        );
      },
    );
  }
}

class ListviewItems extends StatelessWidget {
  ListviewItems({
    Key? key,
    required this.title,
    required this.icon,
  }) : super(key: key);
  final String title;
  // String title2;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 0,
        vertical: 10,
      ),
      child: Container(
        width: 390,
        height: 50,
        child: ListTile(
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 0,
                ),
                child: Container(child: icon),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$title',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'No Events. Click to create one.',
                    style: TextStyle(
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                ],
              ),
            ],
          ),
          hoverColor: Colors.red,
          enabled: true,
          onTap: () {
            fluroRouter.router.navigateTo(
              context,
              '/chat/$title',
            );
          },
        ),
      ),
    );
  }
}
