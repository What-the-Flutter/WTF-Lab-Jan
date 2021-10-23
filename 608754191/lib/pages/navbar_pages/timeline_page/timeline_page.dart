import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hashtagable/hashtagable.dart';
import 'package:hashtagable/widgets/hashtag_text.dart';
import '../../../entity/message.dart';
import 'timeline_page_cubit.dart';

class TimelinePage extends StatefulWidget {
  @override
  _TimelinePageState createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> {
  final TextEditingController _textEditingController = TextEditingController();
  late List<Message> _messageList;

  @override
  void initState() {
    BlocProvider.of<TimelinePageCubit>(context).init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimelinePageCubit, TimelinePageState>(
      builder: (context, state) {
        return _bodyFromTimeline(state);
      },
    );
  }

  void _updateList(TimelinePageState state) {
    if (state.isSortedByBookmarks!) {
      _messageList = state.messageList!.where((element) => element.bookmarkIndex == 1).toList();
    } else if (state.isSearch!) {
      _messageList = state.messageList!
          .where(
            (element) => element.text.contains(_textEditingController.text),
          )
          .toList();
    } else {
      _messageList = state.messageList!;
    }
  }

  Widget _bodyFromTimeline(TimelinePageState state) {
    _updateList(state);
    return ListView.builder(
      reverse: true,
      scrollDirection: Axis.vertical,
      itemCount: _messageList.length,
      itemBuilder: (context, index) {
        final message = _messageList[index];
        return Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 170, 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                  20.0,
                ),
                child: Card(
                  color: Colors.yellow,
                  elevation: 3,
                  child: ListTile(
                    title: message.imagePath != null
                        ? Image.file(
                            File(message.imagePath!),
                          )
                        : HashTagText(
                            text: message.text,
                            basicStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                            decoratedStyle: const TextStyle(
                              color: Colors.yellow,
                              fontSize: 19,
                            ),
                            onTap: (text) {
                              BlocProvider.of<TimelinePageCubit>(context).setTextSearchState(
                                !state.isSearch!,
                              );
                              _textEditingController.text = text;
                            },
                          ),
                    subtitle: Text(
                      message.time,
                      style: TextStyle(
                          color: Theme.of(context).floatingActionButtonTheme.foregroundColor,
                          fontSize: 12),
                    ),
                    trailing: message.bookmarkIndex == 1
                        ? const Icon(
                            Icons.bookmark_border,
                            size: 25,
                            color: Colors.black,
                          )
                        : null,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
