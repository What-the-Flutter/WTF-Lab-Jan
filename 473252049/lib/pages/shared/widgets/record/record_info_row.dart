import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RecordInfoRow extends StatelessWidget {
  final Alignment bubbleAlignment;
  final bool isFavorite;
  final DateTime recordCreateDateTime;

  const RecordInfoRow({
    Key key,
    @required this.bubbleAlignment,
    @required this.isFavorite,
    @required this.recordCreateDateTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: bubbleAlignment == Alignment.centerRight
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      children: [
        if (isFavorite)
          Icon(
            Icons.bookmark,
            size: 12,
          ),
        Text(
          getFormattedRecordCreateDateTime(recordCreateDateTime),
          style: Theme.of(context).textTheme.bodyText2.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
        ),
      ],
    );
  }
}

String getFormattedRecordCreateDateTime(DateTime dateTime) {
  return DateFormat.Hm().format(dateTime);
}
