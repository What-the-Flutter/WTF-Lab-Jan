import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/event_model.dart';
import '../../models/page_model.dart';
import '../../resources/icon_list.dart';
import '../home_screen/cubit.dart';
import 'cubit.dart';
import 'widgets/app_bars.dart';
import 'widgets/event_input_field.dart';
import 'widgets/event_list.dart';

class EventScreen extends StatefulWidget {
  final PageModel page;
  const EventScreen({
    Key? key,
    required this.page,
  }) : super(key: key);

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  final List<EventModel> _favoriteEvents = <EventModel>[];
  final FocusNode _inputNode = FocusNode();
  final TextEditingController _inputController = TextEditingController();
  late final EventScreenCubit cubit;

  @override
  void initState() {
    cubit = BlocProvider.of<EventScreenCubit>(context);
    super.initState();
  }

  @override
  void dispose() {
    _inputController.dispose();
    _inputNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventScreenCubit, EventScreenState>(
      builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: state.containsSelected
              ? MessageClickedAppBar(
                  migrateSelectedEvents: _showMigrateDialog,
                  addToFavorites: _addToFavorites,
                  findEventToEdit: _findEventToEdit,
                  copySelectedEvents: _copySelectedEvents,
                ) as PreferredSizeWidget
              : DefaultAppBar(
                  title: widget.page.name,
                ),
          body: GestureDetector(
            onTap: _hideKeyboard,
            child: Column(
              children: [
                Expanded(
                  child: EventList(),
                ),
                if (state.isCategory)
                  SizedBox(
                    height: 50,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: IconList.iconCategoriesList
                          .map(
                            (e) => CategoryIcon(cubit: cubit, icon: e),
                          )
                          .toList(),
                    ),
                  ),
                EventInputField(
                  editEvent: _editEvent,
                  inputController: _inputController,
                  inputNode: _inputNode,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _copySelectedEvents() async {
    final cubit = BlocProvider.of<EventScreenCubit>(context);
    final eventsToCopy = cubit.copySelectedEvents();
    if (eventsToCopy != '') {
      await Clipboard.setData(ClipboardData(text: eventsToCopy));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 1),
          content: Text('Text copied to clipboard'),
        ),
      );
    }
    cubit.toggleAllSelected();
  }

  Future<void> _showMigrateDialog() async {
    final eventScreenCubit = BlocProvider.of<EventScreenCubit>(context);
    final homeScreenCubit = BlocProvider.of<HomeScreenCubit>(context);
    final listOfPages = homeScreenCubit.state.listOfPages
        .where((element) => element.name != widget.page.name)
        .toList();
    await showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text(
              'Select the page you want to migrate selected events to!',
            ),
            children: listOfPages
                .map(
                  (page) => SimpleDialogOption(
                    child: Text(page.name),
                    onPressed: () {
                      var eventsToMigrate =
                          eventScreenCubit.popSelectedEvents();
                      homeScreenCubit.migrateEventsToPage(
                          page, eventsToMigrate);

                      Navigator.pop(context);
                    },
                  ),
                )
                .toList(),
          );
        });

    eventScreenCubit.toggleAllSelected();
  }

  void _findEventToEdit() {
    final cubit = BlocProvider.of<EventScreenCubit>(context);
    final index = cubit.findSelectedEventIndex();
    _showKeyboard();
    cubit.setIsEditing();
    _inputController.text = cubit.state.page.events[index].text!;
  }

  void _editEvent(String newEventText) {
    final cubit = BlocProvider.of<EventScreenCubit>(context);
    cubit.editEvent(newEventText);
    _hideKeyboard();
    cubit.toggleSelected();
    cubit.setIsEditing();
  }

  void _addToFavorites() {
    final cubit = BlocProvider.of<EventScreenCubit>(context);
    final selectedEvents =
        cubit.state.page.events.where((element) => element.isSelected);
    _favoriteEvents.addAll(selectedEvents);
    cubit.toggleAllSelected();
    setState(() {});
    _favoriteEvents.forEach(print);
  }

  void _showKeyboard() {
    _inputNode.requestFocus();
  }

  void _hideKeyboard() {
    _inputNode.unfocus();
  }
}

class CategoryIcon extends StatefulWidget {
  final IconData icon;
  final EventScreenCubit cubit;

  const CategoryIcon({
    Key? key,
    required this.cubit,
    required this.icon,
  }) : super(key: key);

  @override
  State<CategoryIcon> createState() => _CategoryIconState();
}

class _CategoryIconState extends State<CategoryIcon> {
  bool isSelected = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: IconButton(
        onPressed: () {
          isSelected = true;
          widget.cubit.addCurrentCategory(widget.icon);
        },
        icon: Icon(
          widget.icon,
          color: isSelected
              ? Theme.of(context).primaryColor
              : Theme.of(context).disabledColor,
        ),
      ),
    );
  }
}
