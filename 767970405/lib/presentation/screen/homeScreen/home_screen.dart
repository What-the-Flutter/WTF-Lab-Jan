import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../logic/home_screen_cubit.dart';
import '../../theme/theme_model.dart';
import 'bottom_add_chat.dart';
import 'bottom_panel_tabs.dart';
import 'chat_pages.dart';

class StartWindow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Home')),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.invert_colors),
            onPressed: () {
              Provider.of<ThemeModel>(context, listen: false).toggleTheme();
            },
          ),
        ],
        leading: Icon(Icons.menu),
      ),
      body: BlocBuilder<HomeScreenCubit, HomeScreenInitial>(
        builder: (context, state) => ChatPages(
            pages: context.read<HomeScreenCubit>().repository.eventPages),
      ),
      floatingActionButton: ButtonAddChat(),
      bottomNavigationBar: BottomPanelTabs(),
    );
  }
}
