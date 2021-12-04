import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/entities/event.dart';
import '../cubit/create_event_cubit.dart';

class CreateScreen extends StatelessWidget {
  CreateScreen({
    Key? key,
    this.event,
  }) : super(key: key);

  final Event? event;
  final TextEditingController _eventNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final createEventCubit = context.read<CreateEventCubit>();
    createEventCubit.loadIcons();
    createEventCubit.setEditEvent(event);
    _eventNameController.text = createEventCubit.state.editPage?.title ?? '';

    return Scaffold(
      body: _body(context, createEventCubit),
      floatingActionButton: _floatingActionButton(context),
    );
  }

  FloatingActionButton _floatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _continueCreatingPageOrCancel(context),
      child: _eventNameController.text.isEmpty
          ? const Icon(
              Icons.clear,
              color: Colors.black,
            )
          : const Icon(
              Icons.check,
              color: Colors.black,
            ),
    );
  }

  Widget _body(BuildContext context, CreateEventCubit createPageCubit) {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Container(
        padding: const EdgeInsets.all(30),
        alignment: Alignment.center,
        child: Column(
          children: [
            Text(
              createPageCubit.state.editPage == null ? 'Create New Page' : 'Edit Page',
              style: const TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
              ),
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Name of the Page',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                  TextField(
                    autofocus: true,
                    cursorColor: Theme.of(context).primaryColor,
                    controller: _eventNameController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                  ),
                ],
              ),
            ),
            //TODO
            BlocBuilder<CreateEventCubit, CreateEventState>(
              builder: (context, state) {
                return Expanded(
                  child: GridView.count(
                    padding: const EdgeInsets.all(20),
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    crossAxisCount: 4,
                    children: _iconList(context),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _continueCreatingPageOrCancel(BuildContext context) {
    Navigator.of(context).pop(
      context.read<CreateEventCubit>().createEvent(_eventNameController.text),
    );
  }

  List<Widget> _iconList(BuildContext context) {
    return context.read<CreateEventCubit>().state.icons.map(
      (iconData) {
        return GestureDetector(
          onTap: () {
            context.read<CreateEventCubit>().currentIcon(iconData);
          },
          child: _iconListElement(context, iconData),
        );
      },
    ).toList();
  }

  Stack _iconListElement(BuildContext context, IconData iconData) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        CircleAvatar(
          child: Icon(
            iconData,
            color: Colors.white,
          ),
          radius: 32,
          backgroundColor: Theme.of(context).cardColor,
        ),
        if (context.read<CreateEventCubit>().state.currentIcon == iconData)
          const CircleAvatar(
            radius: 11,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 9,
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              child: Icon(
                Icons.check,
                color: Colors.white,
                size: 17,
              ),
            ),
          ),
      ],
    );
  }
}
