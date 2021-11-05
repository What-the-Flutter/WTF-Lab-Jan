import 'package:flutter/material.dart';
import '../widgets/message_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final listOfChats = const <MessageCard>[
    MessageCard(icon: Icons.travel_explore, title: 'Travel'),
    MessageCard(icon: Icons.bed, title: 'Hotel'),
    MessageCard(icon: Icons.sports_score, title: 'Sport'),
    MessageCard(icon: Icons.dangerous, title: 'Cancel'),
    MessageCard(icon: Icons.data_usage, title: 'Data'),
    MessageCard(icon: Icons.g_mobiledata, title: 'Google'),
    MessageCard(icon: Icons.face, title: 'Friends'),
    MessageCard(icon: Icons.access_alarms, title: 'Alarm'),
    MessageCard(icon: Icons.verified_user, title: 'Protect'),
    MessageCard(icon: Icons.leave_bags_at_home, title: 'No bags'),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: listOfChats.length,
      itemBuilder: (context, index) {
        return listOfChats[index];
      },
    );
  }
}
