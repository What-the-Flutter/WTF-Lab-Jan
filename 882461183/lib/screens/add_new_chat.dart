import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '/models/chat_model.dart';

class AddNewChat extends StatefulWidget {
  const AddNewChat({this.isEditing = false, this.editingChat});

  final bool isEditing;
  final Chat? editingChat;

  @override
  _AddNewChatState createState() => _AddNewChatState();
}

class _AddNewChatState extends State<AddNewChat> {
  final List<_SelectableIcons> _iconsData = [
    _SelectableIcons(Icons.text_fields),
    _SelectableIcons(FontAwesomeIcons.userAstronaut),
    _SelectableIcons(Icons.fitness_center),
    _SelectableIcons(Icons.account_balance),
    _SelectableIcons(Icons.fastfood),
    _SelectableIcons(FontAwesomeIcons.donate),
    _SelectableIcons(FontAwesomeIcons.wineGlassAlt),
    _SelectableIcons(Icons.domain),
    _SelectableIcons(Icons.account_balance_wallet),
    _SelectableIcons(FontAwesomeIcons.dollarSign),
    _SelectableIcons(Icons.shopping_cart),
    _SelectableIcons(Icons.radio),
    _SelectableIcons(Icons.videogame_asset),
    _SelectableIcons(Icons.local_laundry_service),
    _SelectableIcons(Icons.flag),
    _SelectableIcons(Icons.music_note),
    _SelectableIcons(FontAwesomeIcons.pills),
    _SelectableIcons(Icons.event_seat),
    _SelectableIcons(Icons.free_breakfast),
    _SelectableIcons(Icons.pets),
    _SelectableIcons(FontAwesomeIcons.lightbulb),
    _SelectableIcons(Icons.star),
    _SelectableIcons(FontAwesomeIcons.coins),
    _SelectableIcons(Icons.pool),
    _SelectableIcons(Icons.healing),
    _SelectableIcons(Icons.nature_people),
    _SelectableIcons(Icons.time_to_leave),
    _SelectableIcons(FontAwesomeIcons.book),
    _SelectableIcons(Icons.restaurant),
    _SelectableIcons(Icons.cake),
    _SelectableIcons(Icons.local_florist),
    _SelectableIcons(FontAwesomeIcons.chessRook),
    _SelectableIcons(Icons.weekend),
    _SelectableIcons(Icons.vpn_key),
    _SelectableIcons(FontAwesomeIcons.building),
    _SelectableIcons(Icons.import_contacts),
    _SelectableIcons(Icons.flight_takeoff),
    _SelectableIcons(FontAwesomeIcons.basketballBall),
    _SelectableIcons(Icons.access_time),
    _SelectableIcons(FontAwesomeIcons.cookieBite),
    _SelectableIcons(Icons.adjust),
    _SelectableIcons(Icons.save),
    _SelectableIcons(Icons.child_care),
    _SelectableIcons(Icons.highlight),
  ];
  final _controller = TextEditingController();
  bool _isTextfieldEmpty = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      floatingActionButton: _customFloatingActionButton(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 20,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              const Text(
                'Create a new Page',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 20),
              _customTextField(),
              Expanded(
                child: _customGridView(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    if (widget.isEditing) {
      _controller.text = widget.editingChat!.elementName;
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length),
      );
      _isTextfieldEmpty = false;
      for (var element in _iconsData) {
        if (element.icon == widget.editingChat!.icon) {
          element.isSelected = true;
          break;
        }
      }
    } else {
      _isTextfieldEmpty = true;
      _iconsData[0].isSelected = true;
    }
    super.initState();
  }

  Widget _customFloatingActionButton() {
    return FloatingActionButton(
      onPressed: _isTextfieldEmpty ? () => Navigator.pop(context) : _addNewChat,
      child:
          _isTextfieldEmpty ? const Icon(Icons.close) : const Icon(Icons.check),
      backgroundColor: const Color.fromRGBO(254, 215, 65, 1),
      foregroundColor: Colors.black,
      splashColor: Colors.transparent,
    );
  }

  Widget _customTextField() {
    return TextField(
      controller: _controller,
      onChanged: (value) {
        if (_controller.text.isEmpty) {
          _isTextfieldEmpty = true;
        } else {
          _isTextfieldEmpty = false;
        }
        setState(() {});
      },
      autofocus: true,
      cursorColor: Colors.orange[400],
      decoration: InputDecoration(
        filled: true,
        fillColor: Theme.of(context).colorScheme.primaryVariant,
        enabledBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(0),
          borderSide: const BorderSide(style: BorderStyle.none),
        ),
        focusedBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(0),
          borderSide: const BorderSide(style: BorderStyle.none),
        ),
        label: Text(
          'Name of the Page',
          style: TextStyle(color: Colors.orange[400]),
        ),
      ),
    );
  }

  Widget _customGridView() {
    return GridView.builder(
      itemCount: _iconsData.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
      ),
      itemBuilder: (context, index) {
        return Container(
          alignment: Alignment.topCenter,
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primary,
                radius: 24,
                child: IconButton(
                  onPressed: () {
                    for (var i = 0; i < _iconsData.length - 1; i++) {
                      _iconsData[i].isSelected = false;
                    }
                    _iconsData[index].isSelected =
                        !_iconsData[index].isSelected;
                    setState(() {});
                  },
                  icon: Icon(
                    _iconsData[index].icon,
                    size: 29,
                  ),
                  splashColor: Colors.transparent,
                  color: Theme.of(context).colorScheme.surface,
                ),
              ),
              if (_iconsData[index].isSelected)
                CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  radius: 7,
                  child: Icon(
                    Icons.check_circle,
                    color: Colors.green[300],
                    size: 15,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  void _addNewChat() {
    var date = DateTime.now();
    Chat _newChatElement;
    for (var element in _iconsData) {
      if (element.isSelected) {
        if (!widget.isEditing) {
          _newChatElement = Chat(
            icon: element.icon,
            elementName: _controller.text,
            creationDate: date,
            key: UniqueKey(),
          );
          Navigator.pop(context, _newChatElement);
        } else {
          widget.editingChat?.elementName = _controller.text;
          widget.editingChat?.icon = element.icon;
          Navigator.pop(context, widget.editingChat);
        }
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _SelectableIcons {
  final IconData icon;
  bool isSelected = false;

  _SelectableIcons(this.icon);
}
