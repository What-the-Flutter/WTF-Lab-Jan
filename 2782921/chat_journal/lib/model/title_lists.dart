import 'package:chat_journal/model/message_data.dart';
import 'package:chat_journal/navigation/fluro_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'category.dart';

class ListviewItems extends StatelessWidget {
  ListviewItems({
    Key? key,
    required this.category,
    required this.index,
  }) : super(key: key);

  final Category category;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 0,
        vertical: 10,
      ),
      child: Container(
        width: 390,
        height: 50,
        child: ListTile(
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 0,
                ),
                child: Container(child: category.icon),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${category.title}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'No Events. Click to  one.',
                    style: TextStyle(
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                ],
              ),
            ],
          ),
          hoverColor: Colors.red,
          enabled: true,
          onTap: () {
            FluroRouterCubit.router.navigateTo(
              context,
              '/chat/${index}',
            );
          },
        ),
      ),
    );
  }
}
