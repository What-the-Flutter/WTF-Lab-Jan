import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../theme/app_colors.dart';
import '../models/event_model.dart';

class EventInputField extends StatefulWidget {
  final void Function(EventModel) addEvent;

  const EventInputField({
    Key? key,
    required this.addEvent,
  }) : super(key: key);

  @override
  State<EventInputField> createState() => _EventInputFieldState();
}

class _EventInputFieldState extends State<EventInputField> {
  late final TextEditingController _inputController;
  bool _keyboardIsVisible = false;

  @override
  void initState() {
    super.initState();
    _inputController = TextEditingController();
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomOffset = MediaQuery.of(context).viewInsets.bottom;
    _keyboardIsVisible = bottomOffset != 0;
    return Padding(
      padding: EdgeInsets.only(
        bottom: _keyboardIsVisible ? bottomOffset : 12,
      ),
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Flexible(
                child: TextField(
                  controller: _inputController,
                  textInputAction: TextInputAction.done,
                  maxLines: null,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 10,
                    ),
                    hintText: 'Enter Event',
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide(
                        color: AppColors.bluePurple,
                        width: 2,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                ),
              ),
              _keyboardIsVisible
                  ? IconButton(
                      icon: const Icon(
                        Icons.send,
                        color: AppColors.bluePurple,
                      ),
                      onPressed: _addEventModel,
                    )
                  : IconButton(
                      icon: const Icon(
                        Icons.image,
                        color: AppColors.bluePurple,
                      ),
                      onPressed: () {},
                    ),
            ],
          ),
        ),
      ),
    );
  }

  void _addEventModel() {
    if (_inputController.text.isNotEmpty) {
      final model = EventModel(
        text: _inputController.text,
        date: DateFormat.Hm().format(
          DateTime.now(),
        ),
      );
      widget.addEvent(model);
      _inputController.clear();
    }
  }
}
