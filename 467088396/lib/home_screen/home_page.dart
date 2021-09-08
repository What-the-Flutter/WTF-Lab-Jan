import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../constants.dart';
import '../create_screen/create_page.dart';
import '../event_screen/event_page.dart';
import '../models/category.dart';
import '../theme/theme_cubit.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/header_chat_button.dart';
import 'home_cubit.dart';
import 'home_state.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool themeChanged = false;
  int _selectedCategory = -1;

  @override
  void initState() {
    BlocProvider.of<HomeCubit>(context).init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Scaffold(
          appBar: _appBar(),
          body: _body(state),
          floatingActionButton: _floatingActionButton(state),
          bottomNavigationBar: const BottomNavBar(),
        );
      },
    );
  }

  Column _body(HomeState state) {
    var size = MediaQuery.of(context).size;
    return Column(
      children: <Widget>[
        BotButton(size: size),
        _categoryList(state),
      ],
    );
  }

  Expanded _categoryList(HomeState state) {
    return Expanded(
      child: ListView.builder(
        itemCount: state.categoryList.length,
        itemBuilder: (context, index) => _categoryCard(
          index,
          state.categoryList[index],
          state,
        ),
      ),
    );
  }

  GestureDetector _categoryCard(
    int index,
    Category category,
    HomeState state,
  ) {
    return GestureDetector(
      onLongPress: () {
        _selectedCategory = index;
        _showOptions(state);
      },
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => EventPage(category: category)),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(
            horizontal: defaultPadding, vertical: defaultPadding / 2),
        padding: const EdgeInsets.all(defaultPadding / 2),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              spreadRadius: 5,
              blurRadius: 5,
              offset: const Offset(3, 5),
              color: primaryColor.withOpacity(0.10),
            ),
          ],
        ),
        child: ListTile(
          title: Text(
            category.name,
            style: TextStyle(
                color: Theme.of(context).textTheme.caption!.color,
                fontSize: 16,
                fontWeight: FontWeight.w400,
                letterSpacing: 1),
          ),
          subtitle: const Text('No events. Click to create one.'),
          leading: Icon(
            category.iconData,
            color: const Color(0xff87D2F7),
            size: 32,
          ),
        ),
      ),
    );
  }

  FloatingActionButton _floatingActionButton(HomeState state) {
    return FloatingActionButton(
      onPressed: () => _createPage(state),
      elevation: 0,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).floatingActionButtonTheme.backgroundColor,
          borderRadius: const BorderRadius.all(
            Radius.circular(100),
          ),
          boxShadow: [
            BoxShadow(
              spreadRadius: 5,
              blurRadius: 5,
              color: Theme.of(context).primaryColor.withOpacity(0.20),
            ),
          ],
        ),
        child: Icon(
          Icons.add,
          color: Theme.of(context).floatingActionButtonTheme.foregroundColor,
          size: 32,
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  void _createPage(HomeState state) async {
    final category = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => CreatePage()));
    if (category is Category && mounted) {
      BlocProvider.of<HomeCubit>(context).addCategory(category);
    }
  }

  AppBar _appBar() {
    return AppBar(
      elevation: 0,
      leading: IconButton(
        icon: SvgPicture.asset('assets/icons/menu.svg'),
        onPressed: () {},
      ),
      title: const Text(
        'Diary',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w300,
          letterSpacing: 6,
          fontSize: 26,
        ),
      ),
      actions: [
        _changeThemeIconButton(),
      ],
    );
  }

  IconButton _changeThemeIconButton() {
    return IconButton(
      onPressed: () {
        themeChanged = !themeChanged;
        BlocProvider.of<ThemeCubit>(context).changeTheme();
      },
      //iconSize: 28,
      icon: const Icon(Icons.nightlight),
      color: Colors.white,
    );
  }

  Future<dynamic> _showOptions(HomeState state) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.info, color: secondColor),
              title: const Text('Info'),
              onTap: () {
                Navigator.of(context).pop();
                _showInfo(state);
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit_rounded, color: secondColor),
              title: const Text('Edit'),
              onTap: () => _editPage(state),
            ),
            ListTile(
              leading: const Icon(Icons.delete_rounded, color: secondColor),
              title: const Text('Delete'),
              onTap: () {
                BlocProvider.of<HomeCubit>(context)
                    .deleteCategory(_selectedCategory);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future _showInfo(HomeState state) {
    var category = state.categoryList[_selectedCategory];
    var date = category.createdTime;
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(category.iconData),
                title: Text(category.name),
              ),
              const Text('Created'),
              Text('${date.day}.${date.month}.${date.year} at '
                  '${date.hour}:${date.minute}'),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _editPage(HomeState state) async {
    Navigator.pop(context);
    final category = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return CreatePage(
              editCategory: state.categoryList[_selectedCategory]);
        },
      ),
    );
    if (category is Category) {
      BlocProvider.of<HomeCubit>(context).editCategory(
        _selectedCategory,
        category,
      );
    }
  }
}
