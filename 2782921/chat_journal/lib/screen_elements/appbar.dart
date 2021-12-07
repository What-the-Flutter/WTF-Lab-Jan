import 'package:chat_journal/theme/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SimilarScreenTop extends StatelessWidget with PreferredSizeWidget {
  SimilarScreenTop({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  bool darktheme = true;
  @override
  Widget build(BuildContext context) {
    final themeCubit = context.read<ThemeCubit>();
    return AppBar(
      title: const Align(
        child: Text('HOME'),
        alignment: Alignment.center,
      ),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
            right: 20.0,
          ),
          child: IconButton(
            icon: const Icon(
              Icons.nightlight_round,
              size: 24.0,
            ),
            onPressed: themeCubit.changeTheme,
          ),
        ),
      ],
    );
  }
}
