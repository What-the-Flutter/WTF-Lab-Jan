import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/cubit.dart';
import 'event_message.dart';

class EventList extends StatelessWidget {
  EventList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<EventScreenCubit>(context);
    return ListView.builder(
      reverse: true,
      itemCount: cubit.state.page.events.length,
      itemBuilder: (context, index) => EventMessage(
        event: cubit.state.page.events[index],
        index: index,
      ),
    );
  }
}
