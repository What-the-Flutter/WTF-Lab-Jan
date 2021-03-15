import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:try_bloc_app/repository/property_page.dart';

import '../../../database/database.dart';
import '../../creating_new_page/creating_new_page.dart';
import '../home_screen_cubit.dart';

class ButtonAddChat extends StatelessWidget {
  final DBHelper _dbHelper = DBHelper();
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
        await _dbHelper.insertPage(result);
        context.read<HomePageCubit>().addPage(result);
      },
    );
  }
}
