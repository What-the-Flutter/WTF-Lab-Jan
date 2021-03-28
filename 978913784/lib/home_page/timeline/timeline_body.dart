import 'package:chat_journal/settings_page/settings_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widgets/event_message_list.dart';
import '../../widgets/event_message_tile.dart';
import 'timeline_cubit.dart';
import 'timeline_state.dart';

class TimelineBody extends StatefulWidget {
  @override
  _TimelineBodyState createState() => _TimelineBodyState();
}

class _TimelineBodyState extends State<TimelineBody> {
  @override
  void initState() {
    BlocProvider.of<TimelineCubit>(context).initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimelineCubit, TimelineState>(
      builder: (context, state) {
        final _allowed = state.isOnSearch
            ? state.events
                .where(
                    (element) => element.description.contains(state.filter))
                .toList()
            : state.events;

        final _displayed = state.showingFavourites
            ? _allowed.where((event) => event.isFavourite).toList()
            : _allowed;

        return EventMessageList(
          _displayed,
          {},
          state.isDateCentered,
          state.isRightToLeft,
          builder: (event) {
            return EventMessageTile(
              event,
              state.isRightToLeft,
              false,
            );
          },
        );
      },
    );
  }
}
