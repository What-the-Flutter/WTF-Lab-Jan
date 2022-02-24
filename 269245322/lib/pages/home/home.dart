import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../services/firebase_auth_service.dart';
import '../../style/theme_cubit.dart';
import '../bookmarks.dart/bookmarks.dart';
import '../page_constructor/page_constructor.dart';
import '../page_constructor/page_cubit.dart';
import '../page_constructor/page_state.dart';
import '../settings/settings.dart';
import 'pages_list.dart';

class HomePage extends StatefulWidget {
  final ThemeCubit themeCubit;
  const HomePage({
    Key? key,
    required this.themeCubit,
  }) : super(key: key);
  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<HomePage> {
  final PageCubit _pageCubit = PageCubit();
  final AuthService _auth = AuthService();

  @override
  void initState() {
    super.initState();
    _pageCubit.init();
    widget.themeCubit.initState();
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
          backgroundColor: Theme.of(context).backgroundColor,
        );
      },
    );
  }
}

AppBar _appBar(BuildContext context) {
  return AppBar(
    leading: IconButton(
        onPressed: () {
          Navigator.pushNamed(
            context,
            BookmarksPage.routeName,
          );
        },
        icon: Icon(
          Icons.bookmark_border,
          color: Theme.of(context).primaryColorLight,
        )),
    title: const Center(
      child: Text(
        'Home',
      ),
    ),
    actions: [
      IconButton(
        onPressed: () {
          Navigator.pushNamed(
            context,
            SettingsPage.routeName,
          );
        },
        icon: Icon(
          Icons.settings,
          color: Theme.of(context).primaryColorLight,
        ),
      ),
    ],
    backgroundColor: Theme.of(context).primaryColor,
  );
}

FloatingActionButton _floatingActionButton(
  PageCubit _pageCubit,
  BuildContext context,
) {
  return FloatingActionButton(
    onPressed: () => _floatingActionButtonEvent(_pageCubit, context),
    child: Icon(
      Icons.add,
      color: Theme.of(context).primaryColorLight,
      size: 35,
    ),
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
