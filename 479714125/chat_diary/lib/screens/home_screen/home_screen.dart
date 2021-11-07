import 'package:flutter/material.dart';
import 'widgets/chat_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final listOfChats = const <ChatCard>[
    ChatCard(icon: Icons.travel_explore, title: 'Travel'),
    ChatCard(icon: Icons.bed, title: 'Hotel'),
    ChatCard(icon: Icons.sports_score, title: 'Sport'),
    ChatCard(icon: Icons.dangerous, title: 'Cancel'),
    ChatCard(icon: Icons.data_usage, title: 'Data'),
    ChatCard(icon: Icons.g_mobiledata, title: 'Google'),
    ChatCard(icon: Icons.face, title: 'Friends'),
    ChatCard(icon: Icons.access_alarms, title: 'Alarm'),
    ChatCard(icon: Icons.verified_user, title: 'Protect'),
    ChatCard(icon: Icons.leave_bags_at_home, title: 'No bags'),
  ];

  // @override
  // Widget build(BuildContext context) {
  //   return ListView.builder(
  //     itemCount: listOfChats.length,
  //     itemBuilder: (context, index) {
  //       return listOfChats[index];
  //     },
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
