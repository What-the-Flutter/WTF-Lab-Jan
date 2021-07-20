import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../chat_list_tile.dart';
import '../../util/domain.dart';
import '../../theme_bloc/theme_bloc.dart';
import 'home_page_cubit.dart';

class HomePage extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<HomePage> {
  @override
  void initState() {
    BlocProvider.of<HomePageCubit>(context).init(initialCategories);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomePageCubit, HomePageState>(
      builder: (context, state) {
        return Scaffold(
          drawer: Drawer(
            child: ListView(
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(),
                  child: Text('Profile'),
                ),
                ListTile(
                  title: Text('Add profile'),
                  onTap: () {},
                ),
                ListTile(
                  title: Text('Exit'),
                  onTap: () {},
                )
              ],
              padding: EdgeInsets.zero,
            ),
          ),
          body: CategoriesList(categories: state.categoriesList),
          appBar: AppBar(
            title: Center(
              child: Text('Home'),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.invert_colors),
                onPressed: () => BlocProvider.of<ThemeBloc>(context).add(
                  ChangeThemeEvent(),
                ),
              )
            ],
          ),
          bottomNavigationBar: _myBottomNavigationBar(),
          floatingActionButton: FloatingActionButton(
            onPressed: () =>
                BlocProvider.of<HomePageCubit>(context).addCategory(context),
            child: Icon(Icons.add),
          ),
        );
      },
    );
  }

  Widget _myBottomNavigationBar() {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.book),
          backgroundColor: Colors.white60,
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: 'Daily',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.timeline),
          label: 'Timeline',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.explore),
          label: 'Explore',
        ),
      ],
      showUnselectedLabels: true,
    );
  }
}

class CategoriesList extends StatelessWidget {
  final List categories;

  const CategoriesList({
    Key? key,
    required this.categories,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: categories.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Center(
            child: Container(
              width: 350.0,
              height: 60.0,
              padding: const EdgeInsets.all(4.0),
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.android),
                label: Text('Questionnaire Bot'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
          );
        }
        return ChatListTile(
          title: categories[index - 1].name,
          icon: Icon(initialIcons[categories[index - 1].iconIndex]),
          subtitle: categories[index - 1].events.isEmpty
              ? 'No events. Click to create one.'
              : categories[index - 1].events.first.text,
          onTap: () => BlocProvider.of<HomePageCubit>(context).openChat(
            index - 1,
            context,
          ),
          onLongPress: () =>
              BlocProvider.of<HomePageCubit>(context).selectCategoryAction(
            index - 1,
            context,
          ),
        );
      },
      separatorBuilder: (context, index) => const Divider(),
    );
  }
}
