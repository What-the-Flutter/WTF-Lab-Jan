import 'package:flutter/material.dart';
import 'widgets/page_card.dart';

class HomeScreen extends StatefulWidget {
  final List<PageCard> listOfChats;
  const HomeScreen({Key? key, required this.listOfChats}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.listOfChats.length,
      itemBuilder: (context, index) {
        return widget.listOfChats[index];
      },
    );
  }
}
