import 'package:flutter/material.dart';
import '../entity/entities.dart' as entity;
import '../main.dart';

class TopicMaker extends StatefulWidget {
  final BuildContext context;
  final entity.Topic? topic;

  const TopicMaker({Key? key, required this.context, this.topic}) : super(key: key);

  @override
  _TopicMakerState createState() => _TopicMakerState();
}

class _TopicMakerState extends State<TopicMaker> {
  int _selected = -1;
  final _nameController = TextEditingController();
  late final themeInherited = ThemeInherited.of(widget.context)!;

  void _changeSelected(int value) => setState(() => _selected = value);

  @override
  void initState() {
    if (widget.topic != null) {
      _nameController.text = widget.topic!.name;
      _selected = _icons.indexOf(widget.topic!.icon);
    }
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeInherited.preset.colors.backgroundColor,
      appBar: AppBar(
        backgroundColor: themeInherited.preset.colors.themeColor1,
        title: Text(
          widget.topic == null ? 'Create new topic' : 'Edit ${widget.topic!.name}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.brightness_4_rounded),
            tooltip: 'Change theme',
            onPressed: () => setState(themeInherited.changeTheme),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintStyle: TextStyle(color: themeInherited.preset.colors.minorTextColor),
                hintText: 'Enter topic name...',
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: themeInherited.preset.colors.minorTextColor,
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
                color: themeInherited.preset.colors.textColor1,
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
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 30,
                  mainAxisSpacing: 30,
                ),
                padding: const EdgeInsets.all(20),
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: _icons.length,
                itemBuilder: (context, index) {
                  return _iconAvatar(
                    index: index,
                    radius: 40,
                    iconColor: Colors.white,
                    backgroundColor: themeInherited.preset.colors.avatarColor,
                    onSelect: () => _changeSelected(index),
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
                if (_nameController.text.isNotEmpty && _selected != -1) {
                  if (widget.topic == null) {
                    entity.Topic.topics.add(entity.Topic(
                      name: _nameController.text,
                      icon: _icons[_selected],
                    ));
                  } else {
                    if (widget.topic!.name != _nameController.text) {
                      entity.topics.remove(widget.topic!.name);
                      widget.topic!.name = _nameController.text;
                      entity.topics[widget.topic!.name] = widget.topic!;
                    }
                    widget.topic!.icon = _icons[_selected];
                  }
                  Navigator.pop(context);
                }
              },
              child: Text(
                widget.topic == null ? 'Add topic' : 'Save',
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: themeInherited.preset.colors.buttonColor,
        onPressed: () => Navigator.pop(context),
        child: const Icon(Icons.close_rounded),
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
    Icons.sports_esports_rounded,
    Icons.backup_rounded,
    Icons.star_rounded,
    Icons.add_location_rounded,
    Icons.add_shopping_cart_rounded,
    Icons.flutter_dash_rounded,
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
