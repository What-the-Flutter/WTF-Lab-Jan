import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/cubit/home_cubit.dart';
import '../categories/categories_page.dart';
import 'widgets/bottom_navigation_bar.dart';

class HomePage extends StatelessWidget {
  static const routeName = '/home';

  final _tabs = [
    CategoriesPage(),
    const Center(child: Text('2')),
    const Center(child: Text('3')),
    const Center(child: Text('4')),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(),
      child: Scaffold(
        bottomNavigationBar: bottomNavigationBar(),
        body: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            return _tabs[state.index];
          },
        ),
      ),
    );
  }
}
