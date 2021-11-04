import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../entity/page.dart';
import '../main_pages/settings_page/settings_cubit.dart';

class MessageList extends StatelessWidget {
  final bool _isDateCentered;
  final bool _isRightToLeft;
  final List<Event> _displayed;
  final Function(Event) builder;

  MessageList(
      this._displayed,
      this._isDateCentered,
      this._isRightToLeft, {
        required this.builder,
      });

  @override
  Widget build(BuildContext context) {
    if (_displayed.isNotEmpty) {
      final _children = <Widget>[const SizedBox(height: 50)];
      final days = <int>{};
      for (var i = _displayed.length - 1; i >= 0; i--) {
        final day =
            _displayed[i].creationTime.millisecondsSinceEpoch ~/ 86400000;
        if (!days.contains(day)) {
          _children.insert(
            0,
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
              child: Text(
                DateFormat('MMM d, yyyy').format(_displayed[i].creationTime),
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyText1!.color,
                  fontSize: SettingsCubit.calculateSize(context, 15, 18, 25),
                ),
                textAlign: _isDateCentered
                    ? TextAlign.center
                    : BlocProvider.of<SettingsCubit>(context)
                    .state
                    .isRightToLeft
                    ? TextAlign.end
                    : TextAlign.start,
              ),
            ),
          );
          days.add(day);
        }
        _children.insert(
          0,
          builder(_displayed[i]),
        );
      }

      return ListView(
        reverse: true,
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        children: _children,
      );
    } else {
      return Center(
        child: Text(
          'No events yet...',
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyText1!.color!.withOpacity(0.5),
            fontSize: SettingsCubit.calculateSize(context, 15, 20, 30),
          ),
        ),
      );
    }
  }
}