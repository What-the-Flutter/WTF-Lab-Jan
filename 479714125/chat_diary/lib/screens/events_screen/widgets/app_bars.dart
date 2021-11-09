import 'package:chat_diary/screens/events_screen/models/event_model.dart';
import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';

const double appBarHeight = 50;

class DefaultAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const DefaultAppBar({Key? key, required this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AppBar(
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
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(appBarHeight);
}

class MessageClickedAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final bool containsMoreThanOneSelected;
  final void Function() deleteSelectedEvents;
  final void Function() copySelectedEvents;
  final void Function() findEventToEdit;

  const MessageClickedAppBar({
    Key? key,
    required this.containsMoreThanOneSelected,
    required this.deleteSelectedEvents,
    required this.copySelectedEvents,
    required this.findEventToEdit,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: AppColors.bluePurple,
      actions: [
        if (!containsMoreThanOneSelected)
          IconButton(
            onPressed: findEventToEdit,
            icon: const Icon(Icons.edit),
          ),
        IconButton(
          onPressed: copySelectedEvents,
          icon: const Icon(Icons.copy),
        ),
        IconButton(
          onPressed: () {},
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
