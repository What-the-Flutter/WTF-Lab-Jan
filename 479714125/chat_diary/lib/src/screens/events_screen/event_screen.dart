import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'models/event_model.dart';
import 'widgets/app_bars.dart';
import 'widgets/event_input_field.dart';
import 'widgets/event_list.dart';

class EventScreen extends StatefulWidget {
  final String title;

  const EventScreen({Key? key, required this.title}) : super(key: key);

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  final List<EventModel> _events = <EventModel>[];
  final List<EventModel> _favoriteEvents = <EventModel>[];
  final FocusNode _inputNode = FocusNode();
  final TextEditingController _inputController = TextEditingController();

  int _countOfSelected = 0;
  bool _isEditing = false;
  bool _isImageSelected = false;

  bool get _containsSelected => _countOfSelected > 0;

  bool get _containsMoreThanOneSelected => _countOfSelected > 1;

  @override
  void dispose() {
    _inputController.dispose();
    _inputNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _containsSelected
          ? MessageClickedAppBar(
              addToFavorites: _addToFavorites,
              isImageSelected: _isImageSelected,
              findEventToEdit: _findEventToEdit,
              copySelectedEvents: _copySelectedEvents,
              deleteSelectedEvents: _deleteSelectedEvents,
              containsMoreThanOneSelected: _containsMoreThanOneSelected,
            ) as PreferredSizeWidget
          : DefaultAppBar(title: widget.title),
      body: GestureDetector(
        onTap: _hideKeyboard,
        child: Column(
          children: [
            Expanded(
              child: EventList(
                toggleAppBar: _toggleAppBar,
                events: _events,
              ),
            ),
            EventInputField(
              editEvent: _editEvent,
              inputController: _inputController,
              inputNode: _inputNode,
              isSelected: _containsMoreThanOneSelected,
              addEvent: _addEvent,
              isEditing: _isEditing,
            ),
          ],
        ),
      ),
    );
  }

  void _addEvent(EventModel model) {
    setState(() => _events.insert(0, model));
  }

  void _toggleAppBar(int indexOfEvent, bool isSelected) {
    isSelected = !isSelected;
    _events[indexOfEvent].isSelected = isSelected;
    if (_events[indexOfEvent].image == null) {
      setState(() => _countOfSelected = _countSelectedEvents(_events));
    } else {
      setState(() {
        _isImageSelected = !_isImageSelected;
        _countOfSelected = _countSelectedEvents(_events);
      });
    }
  }

  int _countSelectedEvents(List<EventModel> events) {
    var count = 0;
    for (final event in events) {
      if (event.isSelected) {
        count += 1;
      }
    }
    return count;
  }

  void _toggleSelected() {
    for (final event in _events) {
      if (event.isSelected) {
        event.isSelected = false;
      }
    }
    _countOfSelected = 0;
    _isImageSelected = false;
  }

  void _deleteSelectedEvents() {
    _events.removeWhere(
      (element) => element.isSelected,
    );
    _countOfSelected = 0;
    _isImageSelected = false;
    setState(() {});
  }

  void _copySelectedEvents() async {
    final selectedEvents = _events.where((element) => element.isSelected);
    var eventsToCopy = '';
    var isEveryEventImage = true;
    for (final event in selectedEvents) {
      if (event.text != null) {
        isEveryEventImage = false;
        eventsToCopy += event.text!;
        if (event != selectedEvents.last && selectedEvents.last.text != null) {
          eventsToCopy += '\n';
        }
      }
    }
    if (!isEveryEventImage) {
      await Clipboard.setData(ClipboardData(text: eventsToCopy));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 1),
          content: Text('Text copied to clipboard'),
        ),
      );
    }

    _toggleSelected();
    setState(() {});
  }

  void _findEventToEdit() {
    final index = _events.indexWhere((element) => element.isSelected);
    _showKeyboard();
    _isEditing = true;
    _inputController.text = _events[index].text!;

    setState(() {});
  }

  void _editEvent(String newEventText) {
    final index = _events.indexWhere((element) => element.isSelected);
    _events[index].text = newEventText;
    _events[index].isSelected = false;
    _hideKeyboard();
    _countOfSelected = 0;
    _isEditing = false;
    setState(() {});
  }

  void _addToFavorites() {
    final selectedEvents = _events.where((element) => element.isSelected);
    _favoriteEvents.addAll(selectedEvents);
    _toggleSelected();
    setState(() {});
    _favoriteEvents.forEach(print);
  }

  void _showKeyboard() {
    _inputNode.requestFocus();
  }

  void _hideKeyboard() {
    _inputNode.unfocus();
  }
}
