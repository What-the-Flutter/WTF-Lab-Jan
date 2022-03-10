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

    final List<PageModel> pagesList;
    pagesList = info['pagesList'] ?? [];
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
                child: staticticTile(
                  color: Colors.blue[200] as Color,
                  width: 230.0,
                  staticticTileCount: totalNotesCount,
                  staticticTileText: 'Total count',
                )),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  staticticTile(
                    color: Colors.yellow[300] as Color,
                    width: 105.0,
                    staticticTileCount: totalPagesCount,
                    staticticTileText: 'Labels',
                  ),
                  staticticTile(
                    color: Colors.green[300] as Color,
                    width: 105.0,
                    staticticTileCount: totalBookmarksCount,
                    staticticTileText: 'Bookmarks',
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
                  },
                ),
              ),
            ),
          ],
        ));
  }
}

Widget staticticTile({
  required Color color,
  required double width,
  required int staticticTileCount,
  required String staticticTileText,
}) {
  return Container(
    margin: const EdgeInsets.all(10.0),
    width: width,
    color: color,
    child: Column(
      children: [
        Text(
          '$staticticTileCount',
          style: const TextStyle(fontSize: 40.0),
        ),
        Text('$staticticTileText'),
      ],
    ),
  );
}
