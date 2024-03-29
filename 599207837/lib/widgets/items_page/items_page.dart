import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/widgets/theme_provider/theme_state.dart';
import '../theme_provider/theme_cubit.dart';

import '../widgets.dart';
import 'items_page_cubit.dart';
import 'items_page_state.dart';

class ItemsPage extends StatelessWidget {
  const ItemsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ItemsPageCubit()..subscribe(context.read<ThemeCubit>()),
      child: _ItemsPage(),
    );
  }
}

class _ItemsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) => DefaultTabController(
        length: 4,
        child: Scaffold(
          backgroundColor: state.colors.backgroundColor,
          appBar: AppBar(
            backgroundColor: state.colors.themeColor1,
            title: const Text('ChatDiaryApp'),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.settings_rounded),
                tooltip: 'Change theme',
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (newContext) => const SettingsPage(),
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: TabBar(
            indicatorColor: state.colors.underlineColor,
            indicatorWeight: 3,
            tabs: [
              Tab(
                icon: Icon(
                  Icons.amp_stories_rounded,
                  color: state.colors.iconColor1,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.feed_rounded,
                  color: state.colors.iconColor1,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.event_rounded,
                  color: state.colors.iconColor1,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.drive_file_rename_outline,
                  color: state.colors.iconColor1,
                ),
              ),
            ],
            unselectedLabelColor: Colors.black38,
          ),
          body: TabBarView(
            children: [
              const ChatList(
                key: null,
              ),
              _itemsList('Tasks', 0),
              _itemsList('Events', 1),
              _itemsList('Notes', 2),
            ],
          ),
          floatingActionButton: const AddingButton(
            key: Key('MainButton'),
            firstIcon: Icon(
              Icons.add,
              size: 30,
            ),
            secondIcon: Icon(
              Icons.remove,
              size: 30,
            ),
          ),
        ),
      ),
    );
  }

  Widget _itemsList(String title, int type) {
    return BlocBuilder<ItemsPageCubit, ItemsPageState>(
      builder: (context, state) {
        final items = type == 0 ? state.favTasks : (type == 1 ? state.favEvents : state.favNotes);
        return Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Padding(
              child: Text(
                title,
                style: const TextStyle(fontSize: 20),
              ),
              padding: const EdgeInsets.only(top: 16.0),
            ),
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Card(
                    key: ValueKey(item.uuid),
                    margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                    child: Padding(
                      child: ItemColumn(item),
                      padding: const EdgeInsets.all(8.0),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
