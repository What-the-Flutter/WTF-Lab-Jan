import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/page_model.dart';
import '../../events_screen/cubit/cubit.dart';
import '../../events_screen/event_screen.dart';
import '../cubit/cubit.dart';
import 'bottom_sheet_card.dart';

class PageCard extends StatefulWidget {
  final Future<void> Function(BuildContext, PageModel) deletePage;
  final Future<void> Function(BuildContext, PageModel) editPage;
  final BuildContext parentContext;

  const PageCard({
    Key? key,
    required this.deletePage,
    required this.editPage,
    required this.parentContext,
  }) : super(key: key);

  @override
  State<PageCard> createState() => _PageCardState();
}

class _PageCardState extends State<PageCard> {
  late final HomeScreenCubit homeScreenCubit;
  late final EventScreenCubit cubitEventScreen;

  @override
  void initState() {
    homeScreenCubit = BlocProvider.of<HomeScreenCubit>(context);
    cubitEventScreen = BlocProvider.of<EventScreenCubit>(context);
    cubitEventScreen.fetchAllEvents();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
      child: Ink(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          border: Border.all(),
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MultiBlocProvider(
                  providers: [
                    BlocProvider.value(
                      value: cubitEventScreen,
                    ),
                    BlocProvider.value(
                      value: homeScreenCubit,
                    ),
                  ],
                  child: EventScreen(
                    page: cubitEventScreen.state.page,
                  ),
                ),
              ),
            );
          },
          onLongPress: () => _showModalBottomSheet(
            widget.parentContext,
            cubitEventScreen.state.page,
          ),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  child: Icon(
                    cubitEventScreen.state.page.icon,
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cubitEventScreen.state.page.name,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      BlocBuilder<EventScreenCubit, EventScreenState>(
                        builder: (context, state) {
                          return Text(
                            (state.page.events.isEmpty)
                                ? 'No Events. Click to create one.'
                                : eventsText(state.page.events.length),
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String eventsText(int length) {
    if (length == 1) {
      return '$length Event';
    } else {
      return '$length Events';
    }
  }

  void _showModalBottomSheet(BuildContext context, PageModel page) {
    showModalBottomSheet<void>(
      context: context,
      builder: (_) {
        return SizedBox(
          height: 120,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              BottomSheetCard(
                title: 'Edit Page',
                icon: Icons.edit,
                color: Colors.blue,
                action: () async {
                  await widget.editPage(context, page);
                  Navigator.pop(context);
                },
              ),
              BottomSheetCard(
                title: 'Delete Page',
                icon: Icons.delete,
                color: Colors.red,
                action: () async {
                  await widget.deletePage(context, page);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
