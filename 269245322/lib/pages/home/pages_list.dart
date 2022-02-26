import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../main.dart';
import '../../models/page_model.dart';
import '../page/custom_page.dart';
import '../page_constructor/page_constructor.dart';
import '../page_constructor/page_cubit.dart';
import 'home_cubit.dart';
import 'home_state.dart';

class PageList extends StatefulWidget {
  final PageCubit pageCubit;
  final HomeCubit homeCubit = HomeCubit();

  PageList({Key? key, required this.pageCubit}) : super(key: key);

  @override
  State<PageList> createState() => _PageListState();
}

class _PageListState extends State<PageList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget.homeCubit.init();
    return BlocBuilder<HomeCubit, HomeState>(
      bloc: widget.homeCubit,
      builder: (context, state) {
        return Expanded(
          child: ListView.builder(
            itemCount: state.listOfPages!.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 1.0, horizontal: 4.0),
                    child: ListTile(
                      tileColor: Theme.of(context).backgroundColor,
                      key: ValueKey(state.listOfPages![index].cretionDate),
                      leading: Icon(
                        pageIcons[state.listOfPages![index].icon],
                        color: Theme.of(context).iconTheme.color,
                      ),
                      title: Text(
                        state.listOfPages![index].title,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primaryVariant,
                        ),
                      ),
                      subtitle: Text(
                        state.listOfPages![index].notesList.isEmpty
                            ? 'create your first note'
                            : state.listOfPages![index].notesList.last.data,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                      onTap: () async {
                        widget.pageCubit
                            .setCurrentPage(state.listOfPages![index]);
                        await Navigator.pushNamed(
                          context,
                          CustomPage.routeName,
                          arguments: widget.pageCubit,
                        );
                        setState(() {});
                      },
                      onLongPress: () => _onElementLongPress(
                        context: context,
                        pageCubit: widget.pageCubit,
                        listOfPages: state.listOfPages!,
                        index: index,
                        homeCubit: widget.homeCubit,
                      ),
                    ),
                  ),
                  const Divider(
                    height: 0.0,
                    color: Colors.blue,
                    indent: 50.0,
                    endIndent: 50.0,
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}

void _onElementLongPress({
  required BuildContext context,
  required PageCubit pageCubit,
  required List<PageModel> listOfPages,
  required int index,
  required HomeCubit homeCubit,
}) {
  showModalBottomSheet<void>(
    context: context,
    builder: (context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextButton.icon(
            onPressed: () {
              Navigator.pop(context);
              showDialog<String>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Page info'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        'Created: ${listOfPages[index].getCretionDate}',
                      ),
                      Text(
                        'Last event: ${listOfPages[index].getlastModifedDate}',
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ],
                  elevation: 1.0,
                ),
              );
            },
            icon: Icon(
              Icons.info,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            label: Text(
              'Show page info',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          TextButton.icon(
            onPressed: () async {
              pageCubit.setPageToEdit(listOfPages[index]);
              pageCubit.setNewCreateNewPageChecker(false);
              await Navigator.pushNamed(
                context,
                PageConstructor.routeName,
                arguments: pageCubit,
              );
            },
            icon: Icon(
              Icons.edit,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            label: Text(
              'Edit page',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          TextButton.icon(
            onPressed: () {
              homeCubit.deletePage(index, listOfPages[index]);
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.delete,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            label: Text(
              'Delete page',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        ],
      );
    },
  );
}
