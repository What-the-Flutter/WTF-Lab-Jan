import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/event_model.dart';
import '../../../theme/app_colors.dart';
import '../cubit.dart';

class EventMessage extends StatelessWidget {
  final EventModel event;
  final int index;

  const EventMessage({
    Key? key,
    required this.event,
    required this.index,
  }) : super(key: key);

  bool get isTextEvent => (event.image == null && event.text != null);

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<EventScreenCubit>(context);

    return Padding(
      padding: const EdgeInsets.only(
        left: 5,
        bottom: 5,
        top: 5,
        right: 20,
      ),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: GestureDetector(
          onLongPress: () {
            print('index is ${event.index}');
            if (!cubit.state.isSearch) {
              cubit.toggleAppBar(index, event.isSelected);
            }
          },
          onTap: () {
            if (!cubit.state.isSearch) {
              if (event.isSelected) {
                cubit.toggleAppBar(index, event.isSelected);
              }
            }
          },
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: event.isSelected
                  ? AppColors.blue400
                  : Theme.of(context).dialogBackgroundColor,
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (event.category != null) Icon(event.category),
                  isTextEvent
                      ? Text(
                          event.text!,
                          style: const TextStyle(fontSize: 16),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              event.image!,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                  Text(
                    event.date,
                    style: const TextStyle(color: AppColors.grey600),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
