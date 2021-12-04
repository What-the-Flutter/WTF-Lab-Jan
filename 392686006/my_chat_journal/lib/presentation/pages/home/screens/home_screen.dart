import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/entities/event.dart';
import '../../../navigator/router.dart';
import '../../../res/theme_cubit.dart';
import '../cubit/home_page_cubit.dart';
import '../widgets/element_list.dart';
import '../widgets/question_bot.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _body(context),
      drawer: const Drawer(),
      floatingActionButton: _floatingActionButton(),
      bottomNavigationBar: _bottomNavigationBar(),
    );
  }

  Widget _body(BuildContext context) {
    context.read<HomePageCubit>().init();
    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate(
            [
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(Routs.event);
                },
                child: const QuestionBotButton(),
              ),
              const Divider(),
            ],
          ),
        ),
        const ElementList(),
      ],
    );
  }

  BottomNavigationBar _bottomNavigationBar() {
    return BottomNavigationBar(
      showSelectedLabels: true,
      showUnselectedLabels: true,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.note), label: 'Daily'),
        BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Timeline'),
        BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
      ],
    );
  }

  FloatingActionButton _floatingActionButton() {
    return FloatingActionButton(
      elevation: 8,
      backgroundColor: Colors.yellow,
      foregroundColor: Colors.black,
      onPressed: () {
        _createPage(context);
      },
      child: const Icon(Icons.add),
    );
  }

  AppBar _appBar() {
    final themeCubit = context.read<ThemeCubit>();
    return AppBar(
      actions: [
        IconButton(
          icon: themeCubit.isDarkMode
              ? const Icon(Icons.invert_colors)
              : const Icon(Icons.invert_colors_outlined),
          onPressed: themeCubit.changeTheme,
        ),
      ],
      centerTitle: true,
      title: const Text('Home'),
    );
  }

  Future<void> _createPage(BuildContext context) async {
    final newPage = await Navigator.of(context).pushNamed(Routs.createEvent);
    if (newPage is Event) {
      context.read<HomePageCubit>().createEvent(newPage);
    }
  }
}
