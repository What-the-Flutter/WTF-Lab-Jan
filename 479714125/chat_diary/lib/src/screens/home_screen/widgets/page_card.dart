import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/page_model.dart';
import '../../events_screen/event_screen.dart';
import '../cubit/home_screen_cubit.dart';
import 'bottom_sheet_card.dart';

class PageCard extends StatelessWidget {
  final PageModel page;
  final Future<void> Function(BuildContext, PageModel) deletePage;
  final Future<void> Function(BuildContext, PageModel) editPage;
  final BuildContext parentContext;

  const PageCard({
    Key? key,
    required this.page,
    required this.deletePage,
    required this.editPage,
    required this.parentContext,
  }) : super(key: key);

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
                //todo here blocbuildre value
                builder: (context) => EventScreen(
                  page: page,
                ),
              ),
            );
          },
          onLongPress: () => _showModalBottomSheet(parentContext),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  child: Icon(
                    page.icon,
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
                        page.name,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      //todo not homescreencubit but eventscreen cubit
                      BlocBuilder<HomeScreenCubit, HomeScreenState>(
                        builder: (context, state) {
                          return Text(
                            (page.events.isEmpty)
                                ? 'No Events. Click to create one.'
                                : '${page.events.length} Events',
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

  void _showModalBottomSheet(BuildContext context) {
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
                  await editPage(context, page);
                  Navigator.pop(context);
                },
              ),
              BottomSheetCard(
                title: 'Delete Page',
                icon: Icons.delete,
                color: Colors.red,
                action: () async {
                  await deletePage(context, page);
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
