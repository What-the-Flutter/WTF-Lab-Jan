import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'events_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Home', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            onPressed: () => {},
            icon: const Icon(Icons.nightlight_round),
          )
        ],
        backgroundColor: Colors.blueGrey,
        elevation: 10,
      ),
      backgroundColor: Colors.grey[92],
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blueGrey,
              ),
              child: Text(
                  DateFormat('yyyy-MM-dd').format(DateTime.now()).toString()),
            ),
            ListTile(
              leading: const Icon(Icons.card_giftcard),
              title: Text('Help spread the world'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.search),
              title: Text('Search'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: Text('Notifications'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.multiline_chart),
              title: Text('Statistics'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.feedback),
              title: Text('Feedback'),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: ListView(padding: const EdgeInsets.all(8), children: [
        ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.blueGrey[200])),
          onLongPress: () => showModalBottomSheet(
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
                      leading:
                          Icon(Icons.attach_file_outlined, color: Colors.green),
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
              }),
          onPressed: () => {},
          child: ListTile(
            leading: Icon(Icons.smart_toy_outlined),
            title: const Text(
              'Questionnaire bot',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
            ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.import_contacts_outlined),
          title: const Text('Notes',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
          subtitle: Text('No events.Click to create one.',
              style: TextStyle(fontWeight: FontWeight.w300)),
          contentPadding: EdgeInsets.fromLTRB(20, 20, 0, 0),
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => MyListEventsPage(title: 'Notes'))),
          onLongPress: () => showModalBottomSheet(
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
                      leading:
                          Icon(Icons.attach_file_outlined, color: Colors.green),
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
              }),
        ),
        ListTile(
          leading: const Icon(Icons.book),
          title: const Text('Journal',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          subtitle: Text('No events.Click to create one.',
              style: TextStyle(fontWeight: FontWeight.w300)),
          contentPadding: EdgeInsets.fromLTRB(20, 5, 0, 0),
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => MyListEventsPage(title: 'Journal'))),
          onLongPress: () => showModalBottomSheet(
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
                      leading:
                          Icon(Icons.attach_file_outlined, color: Colors.green),
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
              }),
        ),
        ListTile(
          leading: const Icon(Icons.nature_people),
          title: const Text('Gratitude',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          subtitle: Text('No events.Click to create one.',
              style: TextStyle(fontWeight: FontWeight.w300)),
          contentPadding: EdgeInsets.fromLTRB(20, 5, 0, 0),
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => MyListEventsPage(title: 'Gratitude'))),
          onLongPress: () => showModalBottomSheet(
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
                      leading:
                          Icon(Icons.attach_file_outlined, color: Colors.green),
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
              }),
        )
      ]),
      floatingActionButton: FloatingActionButton(
          onPressed: () => {}, child: const Icon(Icons.add)),
    );
  }
}
