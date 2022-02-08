import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../services/firebase_auth_service.dart';
import '../page_constructor/page_constructor.dart';
import '../page_constructor/page_cubit.dart';
import '../page_constructor/page_state.dart';
import '../settings/settings.dart';
import 'pages_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<HomePage> {
  final PageCubit _pageCubit = PageCubit();
  final AuthService _auth = AuthService();

  @override
  void initState() {
    super.initState();
    _anonumousAuthorization();
  }

  void _anonumousAuthorization() async {
    dynamic result = await _auth.signInAnon();
    if (result == null) {
      print('error signing in');
    } else {
      print('signed in');
      print(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PageCubit, PageState>(
      bloc: _pageCubit,
      builder: (context, state) {
        return Scaffold(
          appBar: _appBar(context),
          body: Column(
            children: [
              PageList(
                pageCubit: _pageCubit,
              ),
            ],
          ),
          floatingActionButton: _floatingActionButton(_pageCubit, context),
          bottomNavigationBar: _bottomNavigationBar(state, context),
        );
      },
    );
  }
}

AppBar _appBar(BuildContext context) {
  return AppBar(
    title: const Center(child: Text('Home')),
    leading: const IconButton(
      icon: Icon(Icons.menu),
      onPressed: null,
    ),
    backgroundColor: Theme.of(context).primaryColor,
  );
}

FloatingActionButton _floatingActionButton(
    PageCubit _pageCubit, BuildContext context) {
  return FloatingActionButton(
    onPressed: () => _floatingActionButtonEvent(_pageCubit, context),
    child: const Icon(Icons.add),
  );
}

void _floatingActionButtonEvent(
    PageCubit _pageCubit, BuildContext context) async {
  _pageCubit.setNewCreateNewPageChecker(true);
  await Navigator.pushNamed(
    context,
    PageConstructor.routeName,
    arguments: _pageCubit,
  );
}

BottomNavigationBar _bottomNavigationBar(
    PageState state, BuildContext context) {
  return BottomNavigationBar(
    items: <BottomNavigationBarItem>[
      const BottomNavigationBarItem(
        icon: IconButton(
          onPressed: null,
          icon: Icon(Icons.home),
          padding: EdgeInsets.all(0.0),
        ),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: IconButton(
          onPressed: () {
            Navigator.pushNamed(
              context,
              SettingsPage.routeName,
            );
          },
          icon: const Icon(Icons.settings),
          padding: EdgeInsets.zero,
        ),
        label: 'Settings',
      ),
    ],
    currentIndex: state.selectedPageIndex,
    selectedItemColor: Colors.amber[800],
    onTap: null,
  );
}
