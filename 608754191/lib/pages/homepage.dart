import 'package:flutter/material.dart';
import 'package:task_wtf/pages/entity/ListItem.dart';

class ChatJournal extends StatefulWidget {
  @override
  _ChatJournalState createState() => _ChatJournalState();
}

final String _titleForBlankScreen = 'No events. Click to create one';

class _ChatJournalState extends State<ChatJournal> {
  final List<ListItem> array = [
    ListItem('Travel', _titleForBlankScreen, Icons.airport_shuttle_sharp),
    ListItem('Family', _titleForBlankScreen, Icons.family_restroom_sharp),
    ListItem('Sports', _titleForBlankScreen, Icons.directions_bike),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      appBar: AppBar(
        title: Center(
          child: Text(
            'Home',
            style: TextStyle(color: Colors.black),
          ),
        ),
        actions: [
          IconButton(
            color: Colors.black,
            onPressed: () {},
            icon: Icon(Icons.change_circle_sharp),
          ),
        ],
        leading: IconButton(
          color: Colors.black,
          onPressed: () {},
          icon: Icon(Icons.list),
        ),
        backgroundColor: Colors.blueGrey[800],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: array.length + 1,
              itemBuilder: (
                BuildContext context,
                int index,
              ) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white),
                        padding: MaterialStateProperty.all(
                            EdgeInsets.fromLTRB(1, 1, 1, 1)),
                        overlayColor:
                            MaterialStateProperty.all(Colors.blueGrey[100]),
                        shadowColor: MaterialStateProperty.all(Colors.black),
                        elevation: MaterialStateProperty.all(40),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100))),
                      ),
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image(
                              image: AssetImage("image/bot.png"),
                              height: 50,
                              width: 50,
                              color: Colors.black),
                          Text(
                            'Questionnaire Bot',
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.blueGrey[800],
                                fontFamily: 'Times New Roman',
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.fromLTRB(5, 1, 5, 1),
                  child: Card(
                    child: ListTile(
                      title: Text(array[index - 1].title),
                      subtitle: Text(
                        array[index - 1].subtitle,
                        style: TextStyle(color: Colors.blueGrey[300]),
                      ),
                      leading: CircleAvatar(
                        child: Icon(array[index - 1].iconData),
                        backgroundColor: Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {},
        child: Icon(Icons.add_sharp),
      ),
      bottomNavigationBar: _myBottomNavigationBar(),
    );
  }
}

Widget _myBottomNavigationBar() {
  return BottomNavigationBar(
    backgroundColor: Colors.grey[400],
    items: [
      BottomNavigationBarItem(
        icon: Icon(Icons.home_outlined),
        label: 'Home',
        backgroundColor: Colors.black,
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.article_outlined),
        label: 'Daily',
        backgroundColor: Colors.black,
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.access_time),
        label: 'Timeline',
        backgroundColor: Colors.black,
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.explore),
        label: 'Explore',
        backgroundColor: Colors.black,
      ),
    ],
    showUnselectedLabels: true,
  );
}
