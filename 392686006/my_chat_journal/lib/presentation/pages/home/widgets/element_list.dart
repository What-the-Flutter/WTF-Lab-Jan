import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/entities/event.dart';
import '../../../navigator/router.dart';
import '../cubit/home_page_cubit.dart';
import 'event_info_dialog.dart';

import 'event_list_element.dart';

class ElementList extends StatelessWidget {
  const ElementList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomePageCubit, HomePageState>(
      builder: (context, state) {
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .pushNamed(Routs.event, arguments: state.events[index]);
                },
                onLongPress: () => _showBottomSheetDialog(context, index),
                child: EventListElement(context: context, page: state.events[index]),
              );
            },
            childCount: state.events.length,
          ),
        );
      },
    );
  }

  Future<dynamic> _showBottomSheetDialog(BuildContext context, int index) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        // wrap is needed to compress the height of the bottom sheet dialog
        return Wrap(
          children: <Widget>[
            ListTile(
              onTap: () => _showEventInfo(context, index),
              leading: Icon(
                Icons.info,
                color: Theme.of(context).primaryColor,
              ),
              title: const Text('Info'),
            ),
            ListTile(
              onTap: () => _pinEvent(context, index),
              leading: Icon(
                Icons.attach_file,
                color: Colors.green[500],
              ),
              title: const Text('Pin/Unpin page'),
            ),
            ListTile(
              onTap: () => _editEvent(context, index),
              leading: const Icon(
                Icons.edit,
                color: Colors.blue,
              ),
              title: const Text('Edit Page'),
            ),
            ListTile(
              onTap: () => _deleteEvent(context, index),
              leading: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
              title: const Text('Delete Page'),
            ),
          ],
        );
      },
    );
  }

  void _deleteEvent(BuildContext context, int index) {
    Navigator.of(context).pop();
    context.read<HomePageCubit>().deleteEvent(index);
  }

  Future<void> _editEvent(BuildContext context, int index) async {
    final eventsCubit = context.read<HomePageCubit>();
    final events = eventsCubit.state.events;
    final event = await Navigator.of(context).popAndPushNamed(
      Routs.createEvent,
      arguments: events[index],
    );
    if (event is Event) {
      eventsCubit.editEvent(index, event);
    }
  }

  void _pinEvent(BuildContext context, int index) {
    context.read<HomePageCubit>().pinEvent(index);
    Navigator.of(context).pop();
  }

  void _showEventInfo(BuildContext context, int index) {
    final eventsCubit = context.read<HomePageCubit>();
    final events = eventsCubit.state.events;
    Navigator.of(context).pop();
    showDialog(
      context: context,
      builder: (context) => EventInfoDialog(events: events, index: index),
    );
  }
}
