import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../theme/theme_model.dart';
import '../dialogs/dialogs_page.dart';
import 'home_screen_cubit.dart';
import 'widgets/bottom_add_chat.dart';
import 'widgets/bottom_panel_tabs.dart';

class StartWindow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          alignment: Alignment.center,
          child: Text(
            'Home',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
          ),
        ),
        leading: Icon(
          Icons.menu,
        ),
        actions: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 20),
            child: IconButton(
              onPressed: () {
                Provider.of<ThemeModel>(context, listen: false).changeTheme();
              },
              icon: Icon(Icons.invert_colors),
            ),
          ),
        ],
      ),
      body: BlocBuilder<HomePageCubit, HomeScreenInitial>(
        builder: (context, state) => DialogsPages(dialogs: context.read<HomePageCubit>().repository.dialogPages),
      ),
      floatingActionButton: ButtonAddChat(),
      bottomNavigationBar: BottomPanelTabs(),
    );
  }
}
