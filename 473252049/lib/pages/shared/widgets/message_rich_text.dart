import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../category/cubit/records_cubit.dart';
import '../../search_record_page.dart';

class MessageRichText extends StatefulWidget {
  final String message;
  final List<RecordWithCategory> records;
  final bool isOnSearchPage;

  const MessageRichText(
      {Key key, this.message, this.records, this.isOnSearchPage = false})
      : super(key: key);

  @override
  _MessageRichTextState createState() => _MessageRichTextState();
}

class _MessageRichTextState extends State<MessageRichText> {
  final List<TapGestureRecognizer> tapGestureRecognizers = [];
  final regExp = RegExp(r'(#\w+)');
  List<String> tags;
  List<String> splitStringItems;
  List<TextSpan> textSpanArray = [];

  void initializeTags() {
    tags = regExp.allMatches(widget.message).map((e) => e.group(0)).toList();
    splitStringItems = widget.message.split(regExp);

    for (var i = 0; i < splitStringItems.length; ++i) {
      textSpanArray.add(TextSpan(text: splitStringItems[i]));
      if (i == tags.length) return;
      tapGestureRecognizers.add(
        TapGestureRecognizer()
          ..onTap = () {
            showSearch(
              context: context,
              delegate: SearchRecordPage(
                context: context,
                records: widget.records,
              ),
              query: tags[i],
            );
          },
      );
      textSpanArray.add(
        TextSpan(
          text: tags[i],
          style: TextStyle(decoration: TextDecoration.underline),
          recognizer: widget.isOnSearchPage ?? false
              ? null
              : tapGestureRecognizers.last,
        ),
      );
    }
  }

  @override
  void initState() {
    initializeTags();
    super.initState();
  }

  @override
  void dispose() {
    for (var tapGestureRecognizer in tapGestureRecognizers) {
      tapGestureRecognizer.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.bodyText2,
        children: textSpanArray,
      ),
    );
  }
}
