import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/entities/event.dart';
import '../cubit/create_event_cubit.dart';
import '../widgets/check_submit_for_event_icon.dart';
import '../widgets/event_icon.dart';

class CreateScreen extends StatelessWidget {
  CreateScreen({
    Key? key,
    this.event,
  }) : super(key: key);

  final Event? event;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CreateEventCubit>(
      create: (_) {
        final cubit = CreateEventCubit();
        cubit.init();
        cubit.createOrEditEvent(event);
        cubit.editingController.text = cubit.state.editEvent?.title ?? '';
        return cubit;
      },
      child: Scaffold(
        body: _body(),
        floatingActionButton: _floatingActionButton(),
      ),
    );
  }

  Widget _floatingActionButton() {
    return BlocBuilder<CreateEventCubit, CreateEventState>(
      builder: (context, state) {
        return FloatingActionButton(
          onPressed: () => _continueCreatingPageOrCancel(context),
          child: state.isContinue
              ? const Icon(
                  Icons.check,
                  color: Colors.black,
                )
              : const Icon(
                  Icons.clear,
                  color: Colors.black,
                ),
        );
      },
    );
  }

  Widget _body() {
    return Builder(builder: (context) {
      return Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Container(
          padding: const EdgeInsets.all(30),
          alignment: Alignment.center,
          child: Column(
            children: [
              Text(
                context.read<CreateEventCubit>().state.editEvent == null
                    ? 'Create New Page'
                    : 'Edit Page',
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
                      'Name of the Event',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                    TextField(
                      autofocus: true,
                      cursorColor: Theme.of(context).primaryColor,
                      controller: context.read<CreateEventCubit>().editingController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ],
                ),
              ),
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
    });
  }

  Future<void> _continueCreatingPageOrCancel(BuildContext context) async {
    final cubit = context.read<CreateEventCubit>();
    final event = await cubit.createEvent();
    Navigator.of(context).pop(event);
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
        EventIcon(iconData: iconData),
        if (context.read<CreateEventCubit>().state.currentIcon == iconData)
          const CheckSubmitForEventIcon(),
      ],
    );
  }
}
