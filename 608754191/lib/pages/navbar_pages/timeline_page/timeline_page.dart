import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../entity/category.dart';

class TimelinePage extends StatefulWidget {
  final List<Category> categories;

  TimelinePage({Key? key, required this.categories}) : super(key: key);

  @override
  State<TimelinePage> createState() => _TimelinePage(categories);
}

class _TimelinePage extends State<TimelinePage> {
  List<Category> categories;

  @required
  _TimelinePage(this.categories);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _bodyFromTimelinePage(),
    );
  }

  Widget _bodyFromTimelinePage() {
    return ListView.builder(
      itemCount: categories.first.listMessages.length,
      itemBuilder: (context, index) => Container(
        padding: const EdgeInsets.only(right: 100, top: 5, left: 5),
        width: 40,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Card(
            elevation: 5,
            color: Colors.blueGrey[600],
            child: ListTile(
              title: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  categories.first.listMessages[index].text,
                  style: const TextStyle(fontSize: 20, color: Colors.black),
                ),
              ),
              subtitle: Text(
                DateFormat('yyyy-MM-dd KK:mm:ss').format(categories.first.listMessages[index].time),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
