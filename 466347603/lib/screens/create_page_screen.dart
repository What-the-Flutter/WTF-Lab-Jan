import 'package:flutter/material.dart';

import '../modules/page_info.dart';

class CreatePageScreen extends StatefulWidget {
  const CreatePageScreen({Key? key}) : super(key: key);

  @override
  _CreatePageState createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePageScreen> {
  PageInfo? _receivedPage;
  late IconData _selectedIconData;
  final TextEditingController _pageNameController = TextEditingController();
  final List<IconData> _icons = <IconData>[
    Icons.favorite,
    Icons.ac_unit,
    Icons.wine_bar,
    Icons.coffee,
    Icons.local_pizza,
    Icons.money,
    Icons.car_rental,
    Icons.food_bank,
    Icons.navigation,
    Icons.laptop,
    Icons.umbrella,
    Icons.access_alarm,
    Icons.accessible,
    Icons.account_balance,
    Icons.account_circle,
    Icons.adb,
    Icons.add_alarm,
    Icons.add_alert,
    Icons.airplanemode_active,
    Icons.attach_money,
    Icons.audiotrack,
    Icons.av_timer,
    Icons.backup,
    Icons.beach_access,
    Icons.block,
    Icons.brightness_1,
    Icons.bug_report,
    Icons.bubble_chart,
    Icons.call_merge,
    Icons.camera,
    Icons.change_history,
  ];

  _CreatePageState() {
    _selectedIconData = _icons[0];
  }

  @override
  Widget build(BuildContext context) {
    if (_receivedPage == null) {
      _receivedPage = ModalRoute.of(context)?.settings.arguments as PageInfo?;
      if (_receivedPage != null) {
        _pageNameController.text = _receivedPage!.title;
        final index = _icons.indexOf(_receivedPage!.icon.icon!);
        if (_icons.contains(_receivedPage!.icon.icon)) {
          _icons.insert(0, _icons.removeAt(index));
        } else {
          _icons.insert(0, _receivedPage!.icon.icon!);
        }
        _selectedIconData = _icons[0];
      }
    }

    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 40),
        padding: const EdgeInsets.all(30),
        alignment: Alignment.center,
        child: Column(
          children: [
            Text(
              _receivedPage == null ? 'Create Page' : 'Edit Page',
              style: const TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
              ),
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Name of the Page',
                    style: TextStyle(color: Theme.of(context).accentColor),
                  ),
                  TextField(
                    autofocus: true,
                    cursorColor: Theme.of(context).accentColor,
                    controller: _pageNameController,
                    onChanged: (_) {
                      setState(() {});
                    },
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: GridView.count(
                padding: const EdgeInsets.all(20),
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                crossAxisCount: 4,
                children: _iconList,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createPage,
        child: _pageNameController.text.isEmpty
            ? const Icon(
                Icons.clear,
                color: Colors.black,
              )
            : const Icon(
                Icons.check,
                color: Colors.black,
              ),
      ),
    );
  }

  void _createPage() {
    if (_pageNameController.text.isNotEmpty) {
      final page;
      if (_receivedPage != null) {
        page = _receivedPage as PageInfo;
        page!.title = _pageNameController.text;
        page.icon = Icon(
          _selectedIconData,
          color: Colors.white,
        );
      } else {
        page = PageInfo(
          title: _pageNameController.text,
          icon: Icon(
            _selectedIconData,
            color: Colors.white,
          ),
        );
      }
      Navigator.of(context).pop(page);
    } else {
      Navigator.pop(context);
    }
  }

  List<Widget> get _iconList {
    return _icons.map(
      (iconData) {
        return GestureDetector(
          onTap: () {
            _selectedIconData = iconData;
            setState(() {});
          },
          child: _iconListElement(iconData),
        );
      },
    ).toList();
  }

  Stack _iconListElement(IconData iconData) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        CircleAvatar(
          child: Icon(
            iconData,
            color: Colors.white,
          ),
          radius: 32,
          backgroundColor: Theme.of(context).cardColor,
        ),
        if (_selectedIconData == iconData)
          const CircleAvatar(
            radius: 11,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 9,
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              child: Icon(
                Icons.check,
                color: Colors.white,
                size: 17,
              ),
            ),
          ),
      ],
    );
  }
}
