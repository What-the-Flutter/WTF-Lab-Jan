import 'package:chat_journal/screen_elements/bottom_nv_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/title_lists.dart';
import '../screen_elements/appbar.dart';
import '../services/category_manage.dart';
import '../services/services.dart';
import 'home_cubit.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    BlocProvider.of<HomeCubit>(context).init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimilarScreenTop(
        title: 'Home',
      ),
      drawer: const Drawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: GestureDetector(
              onTap: () {
                print('Qustionary tapped');
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.indigo,
                  borderRadius: BorderRadius.circular(10),
                ),
                width: 350,
                height: 40,
                child: const Align(
                  child: Text(
                    'Questionary Bot',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          BlocBuilder<HomeCubit, HomeState>(
            builder: (_, state) => Expanded(
              child: ListView.builder(
                itemCount: state.categories.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onLongPress: () {
                      customModalBottomSheet(context, index, state);
                    },
                    onTap: () {},
                    child: ListviewItems(
                      category: state.categories[index],
                      index: index,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: BlocBuilder<HomeCubit, HomeState>(
        builder: (_, state) => FloatingActionButton(
          onPressed: () {
            create(state, context);
          },
          tooltip: 'add a title',
          child: const Icon(
            Icons.add,
            size: 30,
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBarCustom(),
    );
  }
}
