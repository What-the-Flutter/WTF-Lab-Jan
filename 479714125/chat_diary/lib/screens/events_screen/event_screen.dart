import 'package:chat_diary/screens/events_screen/widgets/event_list.dart';
import 'package:chat_diary/screens/events_screen/widgets/event_message.dart';
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class EventScreen extends StatelessWidget {
  final String title;

  const EventScreen({Key? key, required this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        backgroundColor: AppColors.bluePurple,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.bookmark_outline),
          ),
        ],
      ),
      body: const EventList(),
    );
  }
}
