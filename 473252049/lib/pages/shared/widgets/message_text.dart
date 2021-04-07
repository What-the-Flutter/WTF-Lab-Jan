import 'package:flutter/material.dart';
import 'package:flutter_parsed_text/flutter_parsed_text.dart';

import '../../category/cubit/records_cubit.dart';
import '../../search_record_page.dart';

class MessageText extends StatelessWidget {
  final String message;
  final List<RecordWithCategory> records;
  final bool isOnSearchPage;

  const MessageText({Key key, this.message, this.records, this.isOnSearchPage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ParsedText(
      style: Theme.of(context).textTheme.bodyText2,
      text: message,
      parse: <MatchText>[
        MatchText(
          pattern: r'(#\w+)',
          style: Theme.of(context).textTheme.bodyText2.copyWith(
                decoration: TextDecoration.underline,
              ),
          onTap: (text) {
            if (!isOnSearchPage) {
              showSearch(
                context: context,
                delegate: SearchRecordPage(
                  context: context,
                  records: records,
                ),
                query: text,
              );
            }
          },
        ),
      ],
    );
  }
}
