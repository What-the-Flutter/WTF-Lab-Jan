import 'package:flutter/material.dart';
import '../../../../domain/entities/event_info.dart';

class CreateScreen extends StatefulWidget {
  const CreateScreen({
    Key? key,
    this.eventInfo,
  }) : super(key: key);

  final EventInfo? eventInfo;

  @override
  _CreateScreenState createState() => _CreateScreenState(eventInfo);
}

class _CreateScreenState extends State<CreateScreen> {
  final FocusNode _focusNode = FocusNode();
  bool updateTextAfterChangingIcon = true;
  EventInfo? _receivedPage;
  late IconData _currentIcon;
  final TextEditingController _pageNameController = TextEditingController();
  final List<IconData> _icons = <IconData>[
    Icons.collections_bookmark,
    Icons.menu_book_outlined,
    Icons.favorite,
    Icons.ac_unit,
    Icons.wine_bar,
    Icons.thumb_up_alt_outlined,
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

  _CreateScreenState(EventInfo? eventInfo);

  @override
  void initState() {
    super.initState();
    _currentIcon = _icons.first;
    if (widget.eventInfo != null) {
      _receivedPage = widget.eventInfo;
    }
  }

  @override
  void dispose() {
    _pageNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_receivedPage != null && updateTextAfterChangingIcon) {
      _pageNameController.text = _receivedPage!.title;
      final currentIndex = _icons.indexOf(_receivedPage!.icon.icon!);
      if (currentIndex != 0) {
        _currentIcon = _receivedPage!.icon.icon!;
      }
    }

    return Scaffold(
      body: _body(context),
      floatingActionButton: _floatingActionButton(),
    );
  }

  FloatingActionButton _floatingActionButton() {
    return FloatingActionButton(
      onPressed: _continueCreatingPageOrCancel,
      child: _pageNameController.text.isEmpty
          ? const Icon(
              Icons.clear,
              color: Colors.black,
            )
          : const Icon(
              Icons.check,
              color: Colors.black,
            ),
    );
  }

  Widget _body(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Container(
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
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                  TextField(
                    focusNode: _focusNode,
                    autofocus: true,
                    cursorColor: Theme.of(context).primaryColor,
                    controller: _pageNameController,
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
                children: _iconList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _continueCreatingPageOrCancel() {
    if (_pageNameController.text.isNotEmpty) {
      EventInfo page;
      if (_receivedPage != null) {
        page = _receivedPage as EventInfo;
        page.title = _pageNameController.text;
        page.icon = Icon(
          _currentIcon,
          color: Colors.white,
        );
      } else {
        page = EventInfo(
          title: _pageNameController.text,
          icon: Icon(
            _currentIcon,
            color: Colors.white,
          ),
        );
      }
      Navigator.of(context).pop(page);
    } else {
      Navigator.pop(context);
    }
  }

  List<Widget> _iconList() {
    return _icons.map(
      (iconData) {
        return GestureDetector(
          onTap: () {
            _currentIcon = iconData;
            setState(() {
              updateTextAfterChangingIcon = false;
            });
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
        if (_currentIcon == iconData)
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
