import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/category_list_bloc.dart';
import 'category_creating_page.dart';
import 'message_list_page.dart';
import 'mockup.dart';
import 'models/category.dart';

class CategoriesListPage extends StatefulWidget {
  const CategoriesListPage({
    Key? key,
  }) : super(key: key);

  @override
  State<CategoriesListPage> createState() => _CategoriesListPageState();
}

class _CategoriesListPageState extends State<CategoriesListPage> {
  final CategoryListBloc _categoryListBloc =
      CategoryListBloc(Mockup.categories);
  final OptionMenuBloc _optionMenuBloc = OptionMenuBloc();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _categoryList(),
        Positioned(
          bottom: 10.0,
          right: 10.0,
          child: FloatingActionButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CategoryCreatingPage(
                  _categoryListBloc,
                ),
              ),
            ),
            tooltip: 'Add entry',
            child: const Icon(Icons.add),
          ),
        ),
        Positioned(
          bottom: 0.0,
          child: _hiddenMenu(),
        ),
      ],
    );
  }

  Widget _categoryList() {
    return BlocBuilder(
      bloc: _categoryListBloc,
      builder: (context, state) {
        final categories = state as List<Category>;
        return ListView.separated(
          padding: const EdgeInsets.all(10),
          itemCount: categories.length,
          itemBuilder: (_, index) {
            final item = categories[index];
            return ListTile(
              leading: Icon(item.icon),
              title: Text(item.name),
              trailing: item.favourite
                  ? const Icon(Icons.attach_file)
                  : const SizedBox(),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MessageListPage(
                    category: item.name,
                  ),
                ),
              ),
              onLongPress: () => _optionMenuBloc.set(item),
            );
          },
          separatorBuilder: (_, __) => const Divider(),
        );
      },
    );
  }

  AlertDialog infoDialog() {
    final tmp = _optionMenuBloc.state!;
    return AlertDialog(
      title: ListTile(
        title: Text(tmp.name),
        leading: Icon(tmp.icon),
      ),
      content: Text('isFavourite: ${tmp.favourite}\n'
          'Created: ${tmp.formattedDate}'),
    );
  }

  Widget _hiddenMenu() {
    return BlocBuilder(
        bloc: _optionMenuBloc,
        builder: (_, state) {
          state as Category?;
          return Visibility(
            child: Container(
              color: Colors.black38,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  ListTile(
                      leading: const Icon(Icons.info),
                      title: const Text('Info'),
                      onTap: () {
                        showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (context) => infoDialog(),
                        );
                        _optionMenuBloc.clear();
                      }),
                  ListTile(
                    leading: const Icon(Icons.attach_file),
                    title: const Text('Pin/Unpin Category'),
                    onTap: () {
                      _categoryListBloc.favourite(state!);
                      _optionMenuBloc.clear();
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.archive),
                    title: const Text('Archive Page'),
                    onTap: () {
                      Mockup.mockup(
                        'Category "${state!.name}" added to archive',
                        context,
                      );
                      _optionMenuBloc.clear();
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.edit),
                    title: const Text('Edit Page'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CategoryCreatingPage(
                            _categoryListBloc,
                            category: state!,
                          ),
                        ),
                      );
                      _optionMenuBloc.clear();
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.delete),
                    title: const Text('Delete Page'),
                    onTap: () {
                      _categoryListBloc.remove(state!);
                      _optionMenuBloc.clear();
                    },
                  ),
                ],
              ),
            ),
            visible: state != null,
          );
        });
  }
}
