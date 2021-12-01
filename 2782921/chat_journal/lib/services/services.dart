import 'package:chat_journal/model/category.dart';
import 'package:chat_journal/screen_elements/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../components/icons.dart';
import '../home_screen/home_cubit.dart';

void create(HomeState state, BuildContext context,
    [String? categoryTitle, int? index]) async {
  final nameController = TextEditingController();
  late String titleName;
  late Icon icon;

  var newTitle = false;

  if (index == null) {
    newTitle = true;
  }

  var category = Category(title: '', icon: const Icon(Icons.home));
  var _iconsize = 40.0;
  return showDialog(
    context: context,
    builder: (context) {
      return SimpleDialog(
        title: const Center(child: Text('Edit the text')),
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: nameController,
                  onChanged: (value) {
                    titleName = value;
                  },
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20.0),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                    hintText: categoryTitle,
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.indigo, width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.indigoAccent, width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  nameController.clear();
                  category.title = titleName;
                  category.icon = icon;

                  newTitle
                      ? context.read<HomeCubit>().addCategory(category)
                      : context
                          .read<HomeCubit>()
                          .editCategory(category, index!);

                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.done,
                  color: Colors.indigo,
                ),
              ),
            ],
          ),
          Container(
            height: 350.0, // Change as per your requirement
            width: 150.0,
            child: GridView.builder(
              itemCount: systemIcons.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4),
              itemBuilder: (context, index) {
                return Card(
                  child: GridTile(
                    child: IconButton(
                      icon: systemIcons[index],
                      iconSize: _iconsize,
                      onPressed: () {
                        icon = systemIcons[index];
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
        elevation: 10,
      );
    },
  );
}
