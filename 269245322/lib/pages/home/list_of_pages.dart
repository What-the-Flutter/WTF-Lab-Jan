import 'package:flutter/material.dart';

import '../../objects/lists.dart';
import '../../page_constructor.dart';
import '../page/custom_page.dart';

class PageList extends StatefulWidget {
  PageList({Key? key}) : super(key: key);

  @override
  State<PageList> createState() => _PageListState();
}

class _PageListState extends State<PageList> {
  String cropDateTimeObject(DateTime fullDate) {
    var croppedDate = '';

    croppedDate =
        '${fullDate.day}.${fullDate.month} at ${fullDate.hour}:${fullDate.minute}';
    return croppedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: listOfPages.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 1.0, horizontal: 4.0),
                child: ListTile(
                  key: ValueKey(listOfPages[index].pageKey),
                  leading: Icon(
                    listOfPages[index].icon,
                  ),
                  title: Text(listOfPages[index].title),
                  subtitle: Text(listOfPages[index].notesList.isEmpty
                      ? 'create your first hote'
                      : listOfPages[index].notesList.last.data),
                  onTap: () async {
                    await Navigator.pushNamed(
                      context,
                      CustomPage.routeName,
                      arguments: listOfPages[index],
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
                                              'Created: ${cropDateTimeObject(listOfPages[index].getCretionDate)}'),
                                          Text(
                                              'Last event: ${cropDateTimeObject(listOfPages[index].getlastModifedDate)}'),
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
                                  await Navigator.pushNamed(
                                    context,
                                    PageConstructor.routeName,
                                    arguments: listOfPages[index],
                                  );
                                  setState(() {
                                    Navigator.pop(context);
                                  });
                                },
                                icon: const Icon(Icons.edit),
                                label: const Text('Edit page'),
                              ),
                              TextButton.icon(
                                onPressed: () => setState(() {
                                  Navigator.pop(context);
                                  listOfPages.remove(listOfPages[index]);
                                }),
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
