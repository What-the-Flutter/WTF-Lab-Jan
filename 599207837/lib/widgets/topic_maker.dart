import 'package:flutter/material.dart';
import '../entity/entities.dart' as entity;
import '../main.dart';

class TopicMaker extends StatefulWidget {
  final ThemeDecorator decorator;

  const TopicMaker({Key? key, required this.decorator}) : super(key: key);

  @override
  _TopicMakerState createState() => _TopicMakerState();
}

class _TopicMakerState extends State<TopicMaker> {
  int _selected = -1;
  final _nameController = TextEditingController();

  void _changeSelected(int value) => setState(() => _selected = value);

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.decorator.theme.backgroundColor,
      appBar: AppBar(
        backgroundColor: widget.decorator.theme.themeColor1,
        title: const Text(
          'Create new topic',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.brightness_4_rounded),
            tooltip: 'Change theme',
            onPressed: () => setState(widget.decorator.theme.changeTheme),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintStyle: TextStyle(color: Colors.grey.shade600),
                hintText: 'Enter topic name...',
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey.shade600,
                    width: 1,
                  ),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.teal,
                    width: 2.5,
                  ),
                ),
              ),
              controller: _nameController,
              style: TextStyle(
                color: widget.decorator.theme.textColor1,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: 450,
              height: 450,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black45,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  const BoxShadow(
                    color: Colors.black12,
                    offset: Offset(7.0, 7.0),
                  ),
                ],
              ),
              child: ListView.builder(
                padding: const EdgeInsets.all(20),
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: _icons.length ~/ 4,
                itemBuilder: (context, index) {
                  return _avatarsRow(
                    index: index,
                    radius: 35,
                    iconColor: Colors.white,
                    backgroundColor: widget.decorator.theme.avatarColor1,
                    onSelect: _changeSelected,
                    selected: _selected,
                  );
                },
              ),
            ),
            const SizedBox(height: 35),
            ElevatedButton(
              style: ButtonStyle(
                padding: MaterialStateProperty.all(const EdgeInsets.all(20)),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                backgroundColor: MaterialStateProperty.all(Colors.teal),
              ),
              onPressed: () {
                if (_nameController.text.isNotEmpty && _selected!=-1) {
                  entity.Topic.topics.add(entity.Topic(name: _nameController.text, icon: _icons[_selected]));
                  Navigator.pop(context);
                }
              },
              child: const Text(
                'Add topic',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: widget.decorator.theme.buttonColor,
        onPressed: () => Navigator.pop(context),
        child: const Icon(Icons.close_rounded),
      ),
    );
  }

  Widget _avatarsRow({
    required int index,
    required double radius,
    required Color iconColor,
    required Color backgroundColor,
    required void Function(int) onSelect,
    required int selected,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _iconAvatar(
            index: index * 4,
            iconColor: iconColor,
            onSelect: () => onSelect(index * 4),
            backgroundColor: backgroundColor,
            radius: radius,
            selected: selected,
          ),
          _iconAvatar(
            index: index * 4 + 1,
            iconColor: iconColor,
            onSelect: () => onSelect(index * 4 + 1),
            backgroundColor: backgroundColor,
            radius: radius,
            selected: selected,
          ),
          _iconAvatar(
            index: index * 4 + 2,
            iconColor: iconColor,
            onSelect: () => onSelect(index * 4 + 2),
            backgroundColor: backgroundColor,
            radius: radius,
            selected: selected,
          ),
          _iconAvatar(
            index: index * 4 + 3,
            iconColor: iconColor,
            onSelect: () => onSelect(index * 4 + 3),
            backgroundColor: backgroundColor,
            radius: radius,
            selected: selected,
          ),
        ],
      ),
    );
  }

  Widget _iconAvatar({
    required int index,
    required double radius,
    required Color iconColor,
    required Color backgroundColor,
    required Function() onSelect,
    required int selected,
  }) {
    return GestureDetector(
      onTap: onSelect,
      child: CircleAvatar(
        radius: radius,
        child: Icon(
          _icons[index],
          color: iconColor,
          size: radius,
        ),
        backgroundColor: index == selected ? Colors.teal : backgroundColor,
      ),
    );
  }

  static final List<IconData> _icons = [
    Icons.account_balance_rounded,
    Icons.access_alarm_rounded,
    Icons.image_rounded,
    Icons.add_ic_call_rounded,
    Icons.agriculture_rounded,
    Icons.android_rounded,
    Icons.backup_rounded,
    Icons.star_rounded,
    Icons.add_location_rounded,
    Icons.add_shopping_cart_rounded,
    Icons.airport_shuttle_rounded,
    Icons.tv_rounded,
    Icons.wb_incandescent_rounded,
    Icons.wb_cloudy_rounded,
    Icons.wifi_tethering_rounded,
    Icons.supervisor_account_rounded,
    Icons.airplanemode_active_rounded,
    Icons.cut_rounded,
    Icons.spa_rounded,
    Icons.sports_motorsports_rounded,
    Icons.child_friendly_rounded,
    Icons.sports_basketball_rounded,
    Icons.videogame_asset_rounded,
    Icons.delete_outline_rounded
  ];
}
