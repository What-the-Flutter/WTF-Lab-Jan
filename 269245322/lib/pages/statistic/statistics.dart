import 'package:flutter/material.dart';

import '../../main.dart';
import '../../models/page_model.dart';

class StatisticsPage extends StatelessWidget {
  StatisticsPage({Key? key}) : super(key: key);

  static const routeName = '/pageStatistics';

  @override
  Widget build(BuildContext context) {
    final info =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final List<PageModel> pagesList = info['pagesList'];
    int totalNotesCount = info['totalNotesCount'];
    int totalPagesCount = info['totalPagesCount'];
    int totalBookmarksCount = info['totalBookmarksCount'];

    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Statistics')),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: Container(
              margin: const EdgeInsets.all(10.0),
              width: 230.0,
              color: Colors.blue[200],
              child: Column(
                children: [
                  Text(
                    '$totalNotesCount',
                    style: const TextStyle(fontSize: 40.0),
                  ),
                  const Text('Total count'),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.all(10.0),
                  width: 105.0,
                  color: Colors.yellow[300],
                  child: Column(
                    children: [
                      Text(
                        '$totalPagesCount',
                        style: const TextStyle(fontSize: 40.0),
                      ),
                      const Text('Labels'),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10.0),
                  width: 105.0,
                  color: Colors.green[300],
                  child: Column(
                    children: [
                      Text(
                        '$totalBookmarksCount',
                        style: const TextStyle(fontSize: 40.0),
                      ),
                      const Text('Bookmarks'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 6,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 100.0,
                    childAspectRatio: 1.0,
                    crossAxisSpacing: 20.0,
                    mainAxisSpacing: 20.0,
                  ),
                  itemCount: pagesList.length,
                  itemBuilder: (context, index) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.grey[300],
                              radius: 35.0,
                              child: Icon(
                                pageIcons[pagesList[index].icon],
                              ),
                            ),
                            Text(
                              '${pagesList[index].numOfNotes}',
                              style: const TextStyle(fontSize: 30.0),
                            ),
                          ],
                        ),
                        Text(pagesList[index].title),
                      ],
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
