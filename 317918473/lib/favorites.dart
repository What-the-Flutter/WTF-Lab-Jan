import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'category.dart';
import 'chat.dart';
import 'main.dart';

class Favorites extends StatefulWidget {
  const Favorites({Key? key}) : super(key: key);

  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  @override
  Widget build(BuildContext context) {
    final _chatMessages = context.read<ChatMessages>();
    final favorites =
        _chatMessages.messages.where((element) => element.isFavorite).toList();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: backgroundColor,
        centerTitle: true,
        title: Text('Favorites'),
      ),
      body: ListView(
        children: favorites
            .map((message) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Message(
                        message: message,
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                        onPressed: () => setState(() =>
                            _chatMessages.removeFavorite(
                                _chatMessages.messages.indexOf(message))),
                      ),
                    ]))
            .toList(),
      ),
    );
  }
}
