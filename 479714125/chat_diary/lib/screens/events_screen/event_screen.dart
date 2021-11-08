import 'package:chat_diary/screens/events_screen/widgets/app_bars.dart';
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import 'models/event_model.dart';
import 'widgets/event_input_field.dart';
import 'widgets/event_list.dart';

class EventScreen extends StatefulWidget {
  final String title;

  const EventScreen({Key? key, required this.title}) : super(key: key);

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  final _events = <EventModel>[];
  bool _eventSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _appBar(),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Column(
          children: [
            Expanded(
              child: EventList(
                toggleAppBar: _toggleAppBar,
                events: _events,
              ),
            ),
            EventInputField(
              isSelected: _eventSelected,
              addEvent: _addEvent,
            ),
          ],
        ),
      ),
    );
  }

  void _addEvent(EventModel model) => setState(
        () => _events.insert(0, model),
      );

  void _toggleAppBar(int indexOfEvent, bool isSelected) {
    print(_events[indexOfEvent].text);
    setState(() => _eventSelected = isSelected);
  }

  PreferredSizeWidget _appBar() {
    if (_eventSelected) {
      return const MessageClickedAppBar();
    } else {
      return DefaultAppBar(title: widget.title);
    }
  }
}
