import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/event_model.dart';
import 'cubit.dart';
import 'widgets/event_message.dart';

class SearchEventScreen extends StatefulWidget {
  final String title;
  const SearchEventScreen({Key? key, required this.title}) : super(key: key);

  @override
  State<SearchEventScreen> createState() => _SearchEventScreenState();
}

class _SearchEventScreenState extends State<SearchEventScreen> {
  final TextEditingController _controller = TextEditingController();
  late final EventScreenCubit _cubit =
      BlocProvider.of<EventScreenCubit>(context);
  late final List<EventModel> _items = [];

  @override
  void initState() {
    _items.addAll(_cubit.state.page.events);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search in ${widget.title}',
            border: InputBorder.none,
            hintStyle: const TextStyle(color: Colors.white30),
          ),
          style: const TextStyle(color: Colors.white, fontSize: 16.0),
          onChanged: filterSearchResults,
        ),
      ),
      body: ListView.builder(
        reverse: true,
        itemCount: _items.length,
        itemBuilder: (context, index) => EventMessage(
          event: _items[index],
          index: index,
        ),
      ),
    );
  }

  void filterSearchResults(String query) {
    final dummySearchList = <EventModel>[];
    dummySearchList.addAll(_cubit.state.page.events);
    if (query.isNotEmpty) {
      final dummyListData = <EventModel>[];
      for (var item in dummySearchList) {
        if (item.text != null) {
          if (item.text!.contains(query)) {
            dummyListData.add(item);
          }
        }
      }

      setState(() {
        _items.clear();
        _items.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        _items.clear();
        _items.addAll(_cubit.state.page.events);
      });
    }
  }
}
