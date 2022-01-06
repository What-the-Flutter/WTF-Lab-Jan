import 'package:flutter/material.dart';

import '../page/custom_page.dart';
import 'page_constructor.dart';
import 'page_qubit.dart';
import 'page_state.dart';

class PageList extends StatefulWidget {
  final PageCubit pageCubit;
  final PageState pageState;
  PageList({Key? key, required this.pageCubit, required this.pageState})
      : super(key: key);

  @override
  State<PageList> createState() => _PageListState();
}

class _PageListState extends State<PageList> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: widget.pageState.listOfPages!.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 1.0, horizontal: 4.0),
                child: ListTile(
                  key: ValueKey(widget.pageState.listOfPages![index].pageKey),
                  leading: Icon(
                    widget.pageState.listOfPages![index].icon,
                  ),
                  title: Text(widget.pageState.listOfPages![index].title),
                  subtitle: Text(
                      widget.pageState.listOfPages![index].notesList.isEmpty
                          ? 'create your first nuote'
                          : widget.pageState.listOfPages![index].notesList.last
                              .data),
                  onTap: () async {
                    widget.pageCubit
                        .setCurrentPage(widget.pageState.listOfPages![index]);
                    await Navigator.pushNamed(
                      context,
                      CustomPage.routeName,
                      arguments: widget.pageCubit,
                    );
                    setState(() {});
                  },
                  onLongPress: () {
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
                                          Text(
                                              'Created: ${widget.pageCubit.cropDateTimeObject(widget.pageState.listOfPages![index].getCretionDate)}'),
                                          Text(
                                              'Last event: ${widget.pageCubit.cropDateTimeObject(widget.pageState.listOfPages![index].getlastModifedDate)}'),
                                        ],
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text('Close'),
                                        ),
                                      ],
                                      elevation: 1.0,
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
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
                                  widget.pageCubit
                                      .setNewCreateNewPageChecker(false);
                                  await Navigator.pushNamed(
                                    context,
                                    PageConstructor.routeName,
                                    arguments: widget.pageCubit,
                                  );
                                  setState(() {
                                    Navigator.pop(context);
                                  });
                                },
                                icon: const Icon(Icons.edit),
                                label: const Text('Edit page'),
                              ),
                              TextButton.icon(
                                onPressed: () =>
                                    widget.pageCubit.deletePage(context, index),
                                icon: const Icon(Icons.delete),
                                label: const Text('Delete page'),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
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
  }
}
