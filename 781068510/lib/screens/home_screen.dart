import 'package:flutter/material.dart';

import '../main.dart';
import 'add_note_page.dart';
import 'info_page/note_info_page.dart';

List<String> titles = ['Home', 'Daily', 'Timeline', 'Explore'];

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String title = 'Home';

  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
          onPressed: () {
            print('menu');
          },
          icon: const Icon(Icons.menu),
        ),
        title: Text(
          title,
          style: const TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              onPressed: () {
                print('theme');
              },
              icon: const Icon(Icons.invert_colors)),
        ],
      ),
      body: buildPages(),
      floatingActionButton: buildFloatingActionButton(),
      bottomNavigationBar: buildBottomNavigationBar(),
    );
  }

  BottomNavigationBar buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      elevation: 0.0,
      currentIndex: index,
      items: [
        const BottomNavigationBarItem(
          icon: Icon(Icons.class_),
          label: 'Home',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.assignment),
          label: 'Daily',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.access_time),
          label: 'Timeline',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.explore),
          label: 'Explore',
        ),
      ],
      onTap: onNavBarTap,
    );
  }

  void onNavBarTap(int index) {
    setState(() {
      this.index = index;
      title = titles[index];
    });
  }

  Widget buildFloatingActionButton() {
    return FloatingActionButton(
      child: const Icon(
        Icons.add,
        //color: Colors.white,
      ),
      //backgroundColor: Colors.black,
      onPressed: () {
        // print('Floating button pressed');
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => AddNote()));
      },
    );
  }

  Widget buildPages() {
    switch (index) {
      case 0:
        return homePage();
      case 1:
        return daily();
      case 2:
        return timeline();
      case 3:
        return explore();
      default:
        return Container();
    }
  }

  Widget homePage() {
    return Column(
      children: <Widget>[
        buildSearchContainer(),
        Flexible(child: homeListView())
      ],
    );
  }

  Widget buildSearchContainer() {
    return Container(
      height: 65,
      color: Colors.white,
      child: Center(
        child: Expanded(
          child: Container(
            margin: const EdgeInsets.all(10),
            height: 60,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: Row(
                children: [
                  Container(
                      padding: const EdgeInsets.only(left: 15),
                      child: const Icon(Icons.search)),
                  Expanded(
                    child: TextFormField(
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(borderSide: BorderSide.none),
                        hintText: 'Search',
                        contentPadding: EdgeInsets.only(left: 10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget homeListView() {
    return ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          return ListTile(
            contentPadding: const EdgeInsets.all(5),
            leading: CircleAvatar(
              radius: 30,
              // backgroundColor: Colors.yellowAccent,
              child: Icon(
                listOfIcons[notes[index].iconIndex],
                size: 30,
              ),
            ),
            title: Text(
              notes[index].title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            subtitle: Text(notes[index].note!.isNotEmpty
                ? notes[index].note!.last.description
                : 'Entry event'),
            onTap: () {
              // print('ListView element $index');
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => NoteInfo(
                      title: notes[index].title,
                      listView: notesList[index],
                      isEditMode: false,
                      isMultiSelection: false,
                      key: UniqueKey()),
                ),
              );
            },
          );
        });
  }

  Widget daily() => Container();

  Widget timeline() => Container();

  Widget explore() => Container();
}
