import 'package:flutter/material.dart';

import '../modules/page_info.dart';
import '../modules/theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedBodyContentIndex = 0;
  int _selectedPageIndex = -1;
  bool _isDarkMode = false;
  final List<PageInfo> _pages = <PageInfo>[
    PageInfo(
      title: 'Journal',
      icon: const Icon(
        Icons.book,
        color: Colors.white,
      ),
    ),
    PageInfo(
      title: 'Notes',
      icon: const Icon(
        Icons.my_library_books,
        color: Colors.white,
      ),
    ),
    PageInfo(
      title: 'Text',
      icon: const Icon(
        Icons.text_fields,
        color: Colors.white,
      ),
    ),
    PageInfo(
      title: 'Some very very very very very '
          ' very very very long title',
      icon: const Icon(
        Icons.favorite,
        color: Colors.white,
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Home'),
        ),
        actions: <Widget>[
          IconButton(
            icon: _isDarkMode
                ? const Icon(Icons.dark_mode)
                : const Icon(Icons.dark_mode_outlined),
            onPressed: _changeTheme,
          ),
        ],
      ),
      drawer: const Drawer(),
      body: _pageList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _createPage(context);
        },
        backgroundColor: Colors.yellow[600],
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
      bottomNavigationBar: _bottomNavigationBar(context),
    );
  }

  void _createPage(BuildContext context) async {
    final page = await Navigator.of(context).pushNamed('/create-screen');
    if (page is PageInfo && mounted) {
      setState(() {
        _pages.add(page);
      });
    }
  }

  void _changeTheme() {
    setState(() {
      InheritedCustomTheme.of(context).changeTheme();
      _isDarkMode ^= true;
    });
  }

  Widget _pageList() {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 10),
      itemCount: _pages.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              '/event-screen',
              arguments: _pages[index],
            );
          },
          onLongPress: () {
            _selectedPageIndex = index;
            _showPageOptions(context);
          },
          child: _pageListElement(index),
        );
      },
    );
  }

  Widget _pageListElement(int index) {
    return ListTile(
      leading: Stack(
        alignment: Alignment.bottomRight,
        children: [
          CircleAvatar(
            child: _pages[index].icon,
            radius: 28,
            backgroundColor: Theme.of(context).cardColor,
          ),
          if (_pages[index].isPinned)
            const Icon(
              Icons.push_pin,
              size: 15,
              color: Colors.black54,
            ),
        ],
      ),
      title: Text(
        _pages[index].title,
        style: const TextStyle(fontSize: 25),
      ),
      subtitle: Text(_pages[index].lastMessage),
    );
  }

  Future<dynamic> _showPageOptions(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: <Widget>[
            ListTile(
              onTap: _showPageInfo,
              leading: Icon(
                Icons.info,
                color: Theme.of(context).primaryColor,
              ),
              title: const Text('Info'),
            ),
            ListTile(
              onTap: _pinPage,
              leading: Icon(
                Icons.attach_file,
                color: Colors.green[500],
              ),
              title: const Text('Pin/Unpin page'),
            ),
            ListTile(
              onTap: _editPage,
              leading: const Icon(
                Icons.edit,
                color: Colors.blue,
              ),
              title: const Text('Edit Page'),
            ),
            ListTile(
              onTap: _deletePage,
              leading: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
              title: const Text('Delete Page'),
            ),
          ],
        );
      },
    );
  }

  void _deletePage() {
    setState(() {
      _pages.removeAt(_selectedPageIndex);
    });
    Navigator.of(context).pop();
  }

  void _editPage() async {
    final page = await Navigator.of(context).popAndPushNamed(
      '/create-screen',
      arguments: _pages[_selectedPageIndex],
    );
    if (page is PageInfo) {
      setState(() {
        _pages[_selectedPageIndex] = page;
      });
    }
  }

  void _pinPage() {
    if (_pages.elementAt(_selectedPageIndex).isPinned) {
      var index = 0;
      while (index < _pages.length && _pages[index].isPinned) {
        index++;
      }
      setState(() {
        _pages.elementAt(_selectedPageIndex).isPinned ^= true;
        _pages.insert(index - 1, _pages.removeAt(_selectedPageIndex));
      });
    } else {
      setState(() {
        _pages.insert(0, _pages.removeAt(_selectedPageIndex));
        _pages[0].isPinned = true;
      });
    }
    Navigator.of(context).pop();
  }

  void _showPageInfo() {
    Navigator.of(context).pop();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: CircleAvatar(
                  child: _pages[_selectedPageIndex].icon,
                  radius: 32,
                  backgroundColor: Theme.of(context).cardColor,
                ),
                title: Text(
                  _pages[_selectedPageIndex].title,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 17),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Created'),
                    Text(_pages[_selectedPageIndex].createDate),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 17),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Latest Event'),
                    Text(_pages[_selectedPageIndex].lastEditDate),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 15,
              ),
              child: ElevatedButton(
                child: Text(
                  'OK',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyText1!.color,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).scaffoldBackgroundColor,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _bottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _selectedBodyContentIndex,
      type: BottomNavigationBarType.fixed,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bookmark_added),
          label: 'Daily',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.timeline),
          label: 'Timeline',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.explore),
          label: 'Explore',
        ),
      ],
      onTap: (index) {
        setState(() {
          _selectedBodyContentIndex = index;
        });
      },
    );
  }
}
