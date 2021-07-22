import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HomePagesList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'New Page',
        child: Icon(Icons.add),
        backgroundColor: Colors.amber,
      ),
    );
  }
}

class HomePagesList extends StatefulWidget {
  const HomePagesList({Key? key}) : super(key: key);

  @override
  _HomePagesListState createState() => _HomePagesListState();
}

class _HomePagesListState extends State<HomePagesList> {
  final _pagesNames = <String>['Journal', 'Notes', 'Gratitude'];
  final _pagesIcons = <IconData>[
    Icons.book,
    Icons.import_contacts_outlined,
    Icons.nature_people_outlined
  ];

  void _showPopupMenu() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.info, color: Colors.teal),
              title: Text('Info'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.attach_file_outlined, color: Colors.green),
              title: Text('Pin/Unpin Page'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.edit, color: Colors.blue),
              title: Text('Edit Page'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.delete, color: Colors.redAccent),
              title: Text('Delete Page'),
              onTap: () {},
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(5),
      itemCount: _pagesNames.length,
      separatorBuilder: (context, index) => Divider(),
      itemBuilder: (context, index) {
        return ListTile(
          onLongPress: _showPopupMenu,
          onTap: () {},
          title: Text(_pagesNames[index],
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
          leading: CircleAvatar(
            backgroundColor: Colors.blueGrey[600],
            radius: 28,
            child: Icon(_pagesIcons[index], size: 35, color: Colors.white),
          ),
          subtitle: Text('No Events. Tap to create one.'),
        );
      },
    );
  }
}
