import 'package:flutter/material.dart';

class ChangeListViewBGColor extends StatefulWidget {
  @override
  _ChangeListViewBGColorState createState() => _ChangeListViewBGColorState();
}

class _ChangeListViewBGColorState extends State<ChangeListViewBGColor> {
  final List<String> _title = [
    'Travel',
    'Family',
    'Sports',
  ];

  final List<String> _subtitle = [
    'No events. Click to create one',
    'No events. Click to create one',
    'No events. Click to create one',
  ];

  final List<IconData> _icon = [
    Icons.airplane_ticket,
    Icons.weekend,
    Icons.sports_baseball_sharp
  ];

  int _selectedIndex = -1;

  void _onSelected(int index) {
    setState(() => _selectedIndex = index);
    Navigator.pushNamed(context, '/events');
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: _title.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) => Container(
        color: _selectedIndex == index ? Colors.lightGreen : Colors.white,
        child: _tile(_title[index], _subtitle[index], _icon[index], index),
      ),
    );
  }

  ListTile _tile(String title, String subtitle, IconData icon, int index) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 20,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          color: Colors.black26,
        ),
      ),
      leading: CircleAvatar(
        backgroundColor: Colors.grey,
        radius: 30,
        child: Icon(
          icon,
          color: Colors.white,
        ),
      ),
      onTap: () => _onSelected(index),
    );
  }
}
