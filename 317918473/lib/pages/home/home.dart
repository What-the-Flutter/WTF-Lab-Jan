import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../main.dart';
import '../../models/category.dart';
import '../../models/theme.dart';
import '../../repository/tags_repository.dart';
import '../../theme/theme_cubit.dart';
import '../chat/chat.dart';
import '../chat/chat_cubit.dart';
import '../create_category/create_category.dart';
import 'home_cubit.dart';

class MyHomePage extends StatelessWidget {
  final scaffoldState = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldState,
        appBar: MyAppBar(),
        body: Column(
          children: [
            _homeImage(),
            _widgetList(context),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreateCategory(),
              ),
            );
          },
          tooltip: 'Increment',
          child: Icon(Icons.add),
        ),
        bottomNavigationBar: _bottomNavigationBar(context),
      ),
    );
  }

  Padding _homeImage() {
    return Padding(
      padding:
          const EdgeInsets.only(top: 20.0, right: 20, left: 20, bottom: 10),
      child: Stack(
        children: [
          Image.asset('assets/img/Rectangle 23.png'),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 250,
              maxHeight: 200,
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 30.0, left: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Relax Sounds',
                    style: TextStyle(
                      fontFamily: 'Alegreya',
                      fontSize: 28,
                      letterSpacing: 1,
                      wordSpacing: 1,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Sometimes the most productive thing you can do is relax.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(120, 40),
                      primary: Colors.white,
                      textStyle: TextStyle(fontSize: 16),
                      onPrimary: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {},
                    child: Text(
                      'Play now',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  BottomNavigationBar _bottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 0,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      onTap: (index) {},
      items: [
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/img/Soundsmusic.svg',
            color: context.read<ThemeCubit>().state.themes.isDark
                ? Colors.white
                : Colors.black,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/img/Usr.svg',
            color: context.read<ThemeCubit>().state.themes.isDark
                ? Colors.white
                : Colors.black,
          ),
          label: '',
        ),
      ],
    );
  }

  Expanded _widgetList(BuildContext context) {
    return Expanded(
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is HomeAwaitInitial) {
            return Center(child: CircularProgressIndicator());
          }
          if (state.categoryList.isEmpty) {
            return Center(child: Text('add Some Category'));
          }
          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            children: state.categoryList.map(
              (category) {
                final index = state.categoryList.indexOf(state.categoryList
                    .firstWhere((element) => element.id == category.id));
                return ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                  leading: Hero(
                    tag: '${category.id}',
                    child: Image.asset(category.assetImage),
                  ),
                  title: Text(
                    category.title,
                    style: TextStyle(color: Colors.white, fontSize: 22),
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider<ChatCubit>(
                        create: (context) =>
                            ChatCubit(category.repository, TagRepository(),category.id),
                        child: Chat(category: category),
                      ),
                    ),
                  ),
                  trailing: Visibility(
                    visible: category.isPin,
                    child: Icon(
                      Icons.attach_file,
                      color: Colors.white,
                    ),
                  ),
                  onLongPress: () => _showBottomSheet(category, index, context),
                  subtitle: Text(
                    category.description,
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                );
              },
            ).toList(),
          );
        },
      ),
    );
  }

  void _showBottomSheet(Category category, int index, BuildContext context) {
    final _textStyle = TextStyle(
      color: Colors.white,
      fontSize: 20,
    );
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: Icon(
                Icons.info,
                color: Colors.tealAccent,
              ),
              title: Text(
                'Info',
                style: _textStyle,
              ),
              onTap: () => _showDialog(index, context),
            ),
            ListTile(
              leading: Icon(
                Icons.attach_file,
                color: Colors.greenAccent,
              ),
              title: Text(
                'Pin/Unpin Category',
                style: _textStyle,
              ),
              onTap: () {
                context.read<HomeCubit>().pin(index);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.edit,
                color: Colors.blueAccent,
              ),
              title: Text(
                'Edit',
                style: _textStyle,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateCategory(
                      index: category,
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.delete,
                color: Colors.redAccent,
              ),
              title: Text(
                'Delete',
                style: _textStyle,
              ),
              onTap: () {
                context.read<HomeCubit>().remove(category.id);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _showDialog(int index, BuildContext context) {
    final category = context.read<HomeCubit>().state.categoryList[index];
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            category.title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          content: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: '${category.id}',
                child: Image.asset(category.assetImage),
              ),
              SizedBox(
                width: 20,
              ),
              Text(
                category.description,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
