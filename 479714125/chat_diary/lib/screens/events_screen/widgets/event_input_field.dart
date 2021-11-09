import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../theme/app_colors.dart';
import '../models/event_model.dart';

class EventInputField extends StatefulWidget {
  final void Function(EventModel) addEvent;
  final bool isSelected;
  final bool isEditing;
  final FocusNode inputNode;
  final TextEditingController inputController;
  final Function(String) editEvent;

  const EventInputField({
    Key? key,
    required this.addEvent,
    required this.isSelected,
    required this.isEditing,
    required this.inputNode,
    required this.inputController,
    required this.editEvent,
  }) : super(key: key);

  @override
  State<EventInputField> createState() => _EventInputFieldState();
}

class _EventInputFieldState extends State<EventInputField> {
  bool _keyboardIsVisible = false;

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
                  focusNode: widget.inputNode,
                  enabled: !widget.isSelected,
                  controller: widget.inputController,
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
    if (widget.inputController.text.isNotEmpty) {
      if (!widget.isEditing) {
        final model = EventModel(
          text: widget.inputController.text,
          date: DateFormat('dd.MM.yy').add_Hm().format(
                DateTime.now(),
              ),
        );
        widget.addEvent(model);
        widget.inputController.clear();
      } else {
        widget.editEvent(widget.inputController.text);
        widget.inputController.clear();
      }
    }
  }
}
