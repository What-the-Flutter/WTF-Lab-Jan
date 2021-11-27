import 'package:flutter/material.dart';

const double appBarHeight = 50;

class DefaultAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const DefaultAppBar({Key? key, required this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: true,
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
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(appBarHeight);
}

class MessageClickedAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final bool containsMoreThanOneSelected;
  final bool isImageSelected;
  final void Function() deleteSelectedEvents;
  final void Function() copySelectedEvents;
  final void Function() findEventToEdit;
  final void Function() addToFavorites;

  const MessageClickedAppBar({
    Key? key,
    required this.containsMoreThanOneSelected,
    required this.deleteSelectedEvents,
    required this.copySelectedEvents,
    required this.findEventToEdit,
    required this.isImageSelected,
    required this.addToFavorites,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      actions: [
        if (!containsMoreThanOneSelected && !isImageSelected)
          IconButton(
            onPressed: findEventToEdit,
            icon: const Icon(Icons.edit),
          ),
        IconButton(
          onPressed: copySelectedEvents,
          icon: const Icon(Icons.copy),
        ),
        IconButton(
          onPressed: addToFavorites,
          icon: const Icon(Icons.bookmark_outline),
        ),
        IconButton(
          onPressed: deleteSelectedEvents,
          icon: const Icon(Icons.delete),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(appBarHeight);
}
