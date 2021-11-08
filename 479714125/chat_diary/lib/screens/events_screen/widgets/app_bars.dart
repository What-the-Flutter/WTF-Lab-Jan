import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';

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
  Size get preferredSize => const Size.fromHeight(50);
}

class MessageClickedAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const MessageClickedAppBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: AppColors.lightBlue,
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
  Size get preferredSize => const Size.fromHeight(50);
}
