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
                      key: ValueKey(state.listOfPages![index].cretionDate),
                      leading: Icon(
                        pageIcons[state.listOfPages![index].icon],
                      ),
                      title: Text(state.listOfPages![index].title),
                      subtitle: Text(state.listOfPages![index].notesList.isEmpty
                          ? 'create your first note'
                          : state.listOfPages![index].notesList.last.data),
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
                          context,
                          widget.pageCubit,
                          state.listOfPages!,
                          index,
                          widget.homeCubit),
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

void _onElementLongPress(BuildContext context, PageCubit pageCubit,
    List<PageModel> listOfPages, int index, HomeCubit homeCubit) {
  showModalBottomSheet<void>(
    context: context,
    builder: (context) {
      return Container(
        height: 200,
        color: Theme.of(context).primaryColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
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
                        Text('Created: ${listOfPages[index].getCretionDate}'),
                        Text(
                            'Last event: ${listOfPages[index].getlastModifedDate}'),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Close'),
                      ),
                    ],
                    elevation: 1.0,
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                );
              },
              icon: const Icon(Icons.info),
              label: Text(
                'Show page info',
                style: TextStyle(
                  color: Theme.of(context).primaryColorLight,
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
                // setState(() {
                //   Navigator.pop(context);
                // });
              },
              icon: const Icon(Icons.edit),
              label: const Text('Edit page'),
            ),
            TextButton.icon(
              onPressed: () {
                homeCubit.deletePage(index, listOfPages[index]);
                Navigator.pop(context);
              },
              icon: const Icon(Icons.delete),
              label: const Text('Delete page'),
            ),
          ],
        ),
      );
    },
  );
}
