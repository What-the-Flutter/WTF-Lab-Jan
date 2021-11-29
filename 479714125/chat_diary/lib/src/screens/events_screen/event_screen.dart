import 'package:chat_diary/src/models/page_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../models/event_model.dart';
import 'widgets/app_bars.dart';
import 'widgets/event_input_field.dart';
import 'widgets/event_list.dart';

class EventScreen extends StatefulWidget {
  final PageModel page;

  const EventScreen({
    Key? key,
    required this.page,
  }) : super(key: key);

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  final List<EventModel> _favoriteEvents = <EventModel>[];
  late final PageModel _page;
  final FocusNode _inputNode = FocusNode();
  final TextEditingController _inputController = TextEditingController();

  int _countOfSelected = 0;
  bool _isEditing = false;
  bool _isImageSelected = false;

  bool get _containsSelected => _countOfSelected > 0;

  bool get _containsMoreThanOneSelected => _countOfSelected > 1;

  @override
  void initState() {
    super.initState();
    _page = widget.page;
  }

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
          : DefaultAppBar(
              title: _page.name,
            ),
      body: GestureDetector(
        onTap: _hideKeyboard,
        child: Column(
          children: [
            Expanded(
              child: EventList(
                toggleAppBar: _toggleAppBar,
                events: _page.events,
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
    setState(() => _page.events.insert(0, model));
  }

  void _toggleAppBar(int indexOfEvent, bool isSelected) {
    isSelected = !isSelected;
    _page.events[indexOfEvent].isSelected = isSelected;
    if (_page.events[indexOfEvent].image == null) {
      setState(() => _countOfSelected = _countSelectedEvents(_page.events));
    } else {
      setState(() {
        _isImageSelected = !_isImageSelected;
        _countOfSelected = _countSelectedEvents(_page.events);
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
    for (final event in _page.events) {
      if (event.isSelected) {
        event.isSelected = false;
      }
    }
    _countOfSelected = 0;
    _isImageSelected = false;
  }

  void _deleteSelectedEvents() {
    _page.events.removeWhere(
      (element) => element.isSelected,
    );
    _countOfSelected = 0;
    _isImageSelected = false;
    setState(() {});
  }

  void _copySelectedEvents() async {
    final selectedEvents = _page.events.where((element) => element.isSelected);
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
    final index = _page.events.indexWhere((element) => element.isSelected);
    _showKeyboard();
    _isEditing = true;
    _inputController.text = _page.events[index].text!;

    setState(() {});
  }

  void _editEvent(String newEventText) {
    final index = _page.events.indexWhere((element) => element.isSelected);
    _page.events[index].text = newEventText;
    _page.events[index].isSelected = false;
    _hideKeyboard();
    _countOfSelected = 0;
    _isEditing = false;
    setState(() {});
  }

  void _addToFavorites() {
    final selectedEvents = _page.events.where((element) => element.isSelected);
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
