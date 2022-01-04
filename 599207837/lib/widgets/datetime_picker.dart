import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../main.dart';

class DateTimePicker extends StatelessWidget {
  DateTimePicker({
    required this.labelText,
    this.selectedDate,
    this.selectedTime,
    required this.selectDate,
    required this.selectTime,
    required this.themeInherited,
  });

  final ThemeInherited themeInherited;
  final String labelText;
  final DateTime? selectedDate;
  final TimeOfDay? selectedTime;
  final ValueChanged<DateTime> selectDate;
  final ValueChanged<TimeOfDay> selectTime;

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1970, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) selectDate(picked);
  }

  Future<void> _selectTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 12, minute: 0),
    );
    if (picked != null && picked != selectedTime) selectTime(picked);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(
          flex: 4,
          child: _InputDropdown(
            labelText: labelText,
            valueText: selectedDate == null ? '' : DateFormat.yMMMd().format(selectedDate!),
            onPressed: () => _selectDate(context),
            themeInherited: themeInherited,
          ),
        ),
        const SizedBox(width: 12.0),
        Expanded(
          flex: 3,
          child: _InputDropdown(
            labelText: 'Scheduled time',
            valueText: selectedTime == null ? '' : selectedTime!.format(context),
            onPressed: () => _selectTime(context),
            themeInherited: themeInherited,
          ),
        ),
      ],
    );
  }
}

class _InputDropdown extends StatelessWidget {
  const _InputDropdown({
    required this.labelText,
    required this.valueText,
    required this.onPressed,
    required this.themeInherited,
  });

  final ThemeInherited themeInherited;
  final String labelText;
  final String valueText;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(color: themeInherited.preset.colors.minorTextColor),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: themeInherited.preset.colors.minorTextColor,
              width: 1,
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: themeInherited.preset.colors.underlineColor,
              width: 2,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              valueText,
              style: TextStyle(color: themeInherited.preset.colors.textColor1),
            ),
            Icon(
              Icons.arrow_drop_down,
              color: themeInherited.preset.colors.minorTextColor,
            ),
          ],
        ),
      ),
    );
  }
}
