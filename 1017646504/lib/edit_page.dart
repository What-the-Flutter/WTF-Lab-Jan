import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'color_theme.dart';
import 'page.dart';

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
  EditPage({required this.page, required this.title});

  final JournalPage page;
  final String title;

  @override
  _EditPageState createState() => _EditPageState(page, title);
}

class _EditPageState extends State<EditPage> {
  _EditPageState(this.page, this.title);

  final JournalPage page;
  final String title;
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
      appBar: _appBar,
      body: _body,
      backgroundColor: ColorThemeData.of(context)!.mainColor,
    );
  }

  PreferredSizeWidget get _appBar => AppBar(
        leading: IconButton(
          onPressed: () => setState(() {
            Navigator.pop(context, false);
          }),
          icon: Icon(
            Icons.arrow_back,
            color: ColorThemeData.of(context)!.accentTextColor,
          ),
        ),
        backgroundColor: ColorThemeData.of(context)!.accentColor,
        actions: [
          IconButton(
            onPressed: () => setState(() {
              page.title = _controller.text;
              Navigator.pop(context, isAllowed);
            }),
            icon: Icon(
              isAllowed ? Icons.check : Icons.close,
              color: ColorThemeData.of(context)!.accentTextColor,
            ),
          ),
        ],
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: ColorThemeData.of(context)!.accentTextColor,
          ),
        ),
      );

  Widget get _body => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _pageInfo,
            Expanded(
              child: GridView.extent(
                maxCrossAxisExtent: 60,
                padding: const EdgeInsets.all(10),
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                children: [
                  ...iconList.map(
                    (e) => GestureDetector(
                      onTap: () {
                        setState(() {
                          page.icon = e;
                        });
                      },
                      child: Center(
                        child: Wrap(
                          children: [
                            CircleAvatar(
                              maxRadius: 30,
                              backgroundColor: ColorThemeData.of(context)!.accentColor,
                              foregroundColor: ColorThemeData.of(context)!.accentTextColor,
                              child: Icon(e),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  Widget get _pageInfo {
    Widget _textField() => TextField(
          onChanged: (text) {
            setState(() {
              isAllowed = text.isNotEmpty;
            });
          },
          cursorColor: ColorThemeData.of(context)!.accentTextColor,
          style: TextStyle(
            color: ColorThemeData.of(context)!.accentTextColor,
            fontWeight: FontWeight.bold,
          ),
          controller: _controller,
          decoration: InputDecoration(
            hintText: 'Write page name...',
            hintStyle: TextStyle(
              color: ColorThemeData.of(context)!.accentTextColor.withOpacity(0.5),
            ),
            border: InputBorder.none,
          ),
        );

    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(5),
        ),
        color: ColorThemeData.of(context)!.accentColor,
      ),
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.all(5),
      child: Row(
        children: [
          CircleAvatar(
            maxRadius: 20,
            foregroundColor: ColorThemeData.of(context)!.accentTextColor,
            backgroundColor: ColorThemeData.of(context)!.accentColor,
            child: Icon(
              page.icon,
            ),
          ),
          Expanded(
            flex: 5,
            child: _textField(),
          ),
        ],
      ),
    );
  }
}
