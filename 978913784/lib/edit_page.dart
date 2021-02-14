import 'package:chat_journal/page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'app_theme.dart';

final List<IconData> iconList = [
  Icons.close,
  Icons.add,
  Icons.wb_sunny,
  Icons.access_alarms,
  Icons.workspaces_filled,
  Icons.wine_bar,
  Icons.whatshot_rounded,
  Icons.wb_cloudy_rounded,
  Icons.account_balance,
  Icons.water_damage,
  Icons.account_circle_sharp,
];

class EditPage extends StatefulWidget {
  EditPage({@required this.page});

  final JournalPage page;

  @override
  _EditPageState createState() => _EditPageState(page);
}

class _EditPageState extends State<EditPage> {
  _EditPageState(this.page);

  final JournalPage page;
  final _controller = TextEditingController();
  bool isAllowed = true;

  @override
  void initState() {
    _controller.text = page.title;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => setState(() {
            Navigator.pop(context, false);
          }),
          icon: Icon(Icons.arrow_back),
        ),
        backgroundColor: AppThemeData.of(context).accentColor,
        actions: [
          IconButton(
            onPressed: () => setState(() {
              page.title = _controller.text;
              Navigator.pop(context, isAllowed);
            }),
            icon: Icon(isAllowed ? Icons.check : Icons.close),
          ),
        ],
        title: Text('New page'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: CircleAvatar(
                    maxRadius: 20,
                    foregroundColor: AppThemeData.of(context).accentTextColor,
                    backgroundColor: AppThemeData.of(context).accentColor,
                    child: Icon(
                      page.icon,
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: TextField(
                    onChanged: (text) {
                      setState(() {
                        isAllowed = text.isNotEmpty;
                      });
                    },
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Write page name...',
                      hintStyle: TextStyle(
                        color: AppThemeData.of(context)
                            .mainTextColor
                            .withOpacity(0.5),
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                  ),
                  itemCount: iconList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          page.icon = iconList[index];
                        });
                      },
                      child: Center(
                        child: Wrap(
                          children: [
                            CircleAvatar(
                              maxRadius: 20,
                              backgroundColor:
                                  AppThemeData.of(context).accentColor,
                              foregroundColor:
                                  AppThemeData.of(context).accentTextColor,
                              child: Icon(iconList[index]),
                            )
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
