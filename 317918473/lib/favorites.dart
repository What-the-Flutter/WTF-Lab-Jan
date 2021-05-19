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
  late ChatMessages _chatMessages;
  late List<Messages> _favorites;

  @override
  void initState() {
    super.initState();
    _chatMessages = context.read<ChatMessages>();
    _favorites =
        _chatMessages.messages.where((element) => element.isFavorite).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: backgroundColor,
        centerTitle: true,
        title: Text('Favorites'),
      ),
      body: ListView(
        children: _favorites.map((message) {
          return Row(
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
                  onPressed: () => _removeFromFavorite(message),
                ),
              ]);
        }).toList(),
      ),
    );
  }

  void _removeFromFavorite(Messages message) {
    setState(() =>
        _chatMessages.removeFavorite(_chatMessages.messages.indexOf(message)));
  }
}
