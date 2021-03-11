import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../logic/home_screen_cubit.dart';
import '../../../../repository/property_page.dart';

import '../create_new_page.dart';

class ButtonAddChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      elevation: 10.0,
      child: Icon(
        Icons.add,
        color: Colors.black,
      ),
      onPressed: () async {
        final result = await Navigator.pushNamed(
          context,
          CreateNewPage.routName,
          arguments: PropertyPage(
            title: '',
            icon: Icons.title,
          ),
        );
        context.read<HomePageCubit>().addPage(result);
      },
    );
  }
}
