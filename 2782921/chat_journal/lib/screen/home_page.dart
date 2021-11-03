import 'package:flutter/material.dart';
import '../navigation/fluro_router.dart';
import 'appbar.dart';
import 'bottom_nv_bar.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                width: 350,
                height: 40,
                child: const Align(
                  child: Text(
                    'Questionary Bot',
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                ListviewItems(
                  title: 'Travel',
                  iconc: const Icon(
                    Icons.card_travel,
                    size: 40,
                  ),
                ),
                ListviewItems(
                  title: 'Family',
                  iconc: const Icon(
                    Icons.living_rounded,
                    size: 40,
                  ),
                ),
                ListviewItems(
                  title: 'Sports',
                  iconc: const Icon(
                    Icons.sports_mma,
                    size: 40,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        focusColor: Colors.indigoAccent,
        onPressed: () {},
        tooltip: 'Increment',
        child: const Icon(
          Icons.add,
          size: 30,
        ),
      ),
      bottomNavigationBar: BottomNavigationBarCustom(),
    );
  }
}

class ListviewItems extends StatelessWidget {
  ListviewItems({
    Key? key,
    required this.title,
    required this.iconc,
  }) : super(key: key);
  final String title;
  // String title2;
  final Widget iconc;

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
                child: Container(child: iconc),
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
              // const Divider(
              //   thickness: 12,
              //   color: Colors.black,
              // )
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
