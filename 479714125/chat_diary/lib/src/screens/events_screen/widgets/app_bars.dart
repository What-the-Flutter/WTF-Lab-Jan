import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/cubit.dart';
import '../search_events_screen.dart';

const double appBarHeight = 50;

class DefaultAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const DefaultAppBar({
    Key? key,
    required this.title,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<EventScreenCubit>(context);
    return AppBar(
      title: Text(title),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider.value(
                  value: cubit,
                  child: SearchEventScreen(
                    title: title,
                  ),
                ),
              ),
            );
          },
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
  final void Function() copySelectedEvents;
  final void Function() findEventToEdit;
  final void Function() addToFavorites;
  final void Function() migrateSelectedEvents;

  const MessageClickedAppBar({
    Key? key,
    required this.copySelectedEvents,
    required this.findEventToEdit,
    required this.addToFavorites,
    required this.migrateSelectedEvents,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<EventScreenCubit>(context);
    return AppBar(
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: migrateSelectedEvents,
          icon: const Icon(Icons.reply),
        ),
        if (!cubit.state.containsMoreThanOneSelected &&
            !cubit.state.isImageSelected)
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
          onPressed: cubit.deleteSelectedEvents,
          icon: const Icon(Icons.delete),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(appBarHeight);
}
