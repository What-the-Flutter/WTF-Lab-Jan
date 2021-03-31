import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../dialogs/date_time_picker_dialog.dart';

class RecordCreateDateTimeChoiceButton extends StatelessWidget {
  final DateTime createRecordDateTime;
  final Function setCreateRecordDateTime;

  const RecordCreateDateTimeChoiceButton({
    Key key,
    @required this.createRecordDateTime,
    @required this.setCreateRecordDateTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () async {
        final dateTime = await showDateTimePickerDialog(
          context,
          initialDateTime: createRecordDateTime,
        );
        setCreateRecordDateTime(dateTime);
      },
      child: Text(
        '${DateFormat.yMEd().add_Hm().format(createRecordDateTime)}',
      ),
    );
  }
}
