import 'package:flutter/material.dart';
import '../chat_page/chat_page.dart';
import '../entity/list_item.dart';

class ChatJournalHomePage extends StatefulWidget {
  final List<Category> categories;

  const ChatJournalHomePage({Key? key, required this.categories}) : super(key: key);

  @override
  _ChatJournalHomePageState createState() => _ChatJournalHomePageState();
}

final String _titleForBlankScreen = 'No events. Click to create one';

class _ChatJournalHomePageState extends State<ChatJournalHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      appBar: _appBarFromHomePage(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.categories.length + 1,
              itemBuilder: (
                context,
                index,
              ) {
                if (index == 0) {
                  return _firstConditionPadding();
                }
                return Padding(
                  padding: const EdgeInsets.fromLTRB(5, 2, 5, 1),
                  child: Card(
                    child: ListTile(
                      title: Text(widget.categories[index - 1].title),
                      subtitle: Text(
                        widget.categories[index - 1].subtitle,
                        style: TextStyle(
                          color: Colors.blueGrey[300],
                        ),
                      ),
                      leading: CircleAvatar(
                        child: Icon(widget.categories[index - 1].iconData),
                        backgroundColor: Colors.black,
                      ),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ChatPage(
                            key: widget.key,
                            category: widget.categories[index - 1],
                          ),
                        ),
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
        child: const Icon(Icons.add_sharp),
      ),
      bottomNavigationBar: _myBottomNavigationBar(),
    );
  }

  AppBar _appBarFromHomePage() {
    return AppBar(
      title: const Center(
        child: Text(
          'Home',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      actions: [
        IconButton(
          color: Colors.black,
          onPressed: () {},
          icon: const Icon(Icons.invert_colors),
        ),
      ],
      leading: IconButton(
        color: Colors.black,
        onPressed: () {},
        icon: const Icon(Icons.list),
      ),
      backgroundColor: Colors.blueGrey[800],
    );
  }

  Padding _firstConditionPadding() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.white),
          padding: MaterialStateProperty.all(const EdgeInsets.fromLTRB(1, 1, 1, 1)),
          overlayColor: MaterialStateProperty.all(Colors.blueGrey[100]),
          shadowColor: MaterialStateProperty.all(Colors.black),
          elevation: MaterialStateProperty.all(40),
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(100))),
        ),
        onPressed: () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Image(
              image: AssetImage('image/bot.png'),
              height: 50,
              width: 50,
              color: Colors.black,
            ),
            Text(
              'Questionnaire Bot',
              style: TextStyle(
                fontSize: 15,
                color: Colors.blueGrey[800],
                fontFamily: 'Times New Roman',
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _myBottomNavigationBar() {
    return BottomNavigationBar(
      backgroundColor: Colors.grey[400],
      items: [
        const BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: 'Home',
          backgroundColor: Colors.black,
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.article_outlined),
          label: 'Daily',
          backgroundColor: Colors.black,
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.access_time),
          label: 'Timeline',
          backgroundColor: Colors.black,
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.explore),
          label: 'Explore',
          backgroundColor: Colors.black,
        ),
      ],
      showUnselectedLabels: true,
    );
  }
}
