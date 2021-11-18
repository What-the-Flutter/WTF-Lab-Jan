import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:jiffy/jiffy.dart';
import 'package:linkfy_text/linkfy_text.dart';

import '../../models/events_model.dart';
import '../../theme/themes.dart';
import '../background_image/background_image_cubit.dart';
import '../settings/settings_cubit.dart';
import '../settings/settings_state.dart';
import 'event_page_cubit.dart';
import 'event_page_state.dart';

class EventPage extends StatefulWidget {
  final EventPages eventPage;

  const EventPage({
    Key? key,
    required this.eventPage,
  }) : super(key: key);

  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  final _controller = TextEditingController();
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<EventPageCubit>(context).init(widget.eventPage.id);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final first = Theme.of(context).colorScheme.secondary;
    final second = Theme.of(context).colorScheme.onSecondary;
    final third = Theme.of(context).colorScheme.secondaryVariant;
    return BlocBuilder<EventPageCubit, EventPageState>(
      builder: (blocContext, state) {
        if (BlocProvider.of<BackgroundImageCubit>(context)
            .state
            .isImageSetted) {
          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: FileImage(
                  File(BlocProvider.of<BackgroundImageCubit>(context)
                      .state
                      .imagePath),
                ),
              ),
            ),
            child: _scaffold(state),
          );
        } else {
          return AnimatedContainer(
            duration: const Duration(seconds: 2),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  first,
                  state.isColorChanged ? second : first,
                  state.isColorChanged ? third : first,
                ],
              ),
            ),
            child: _scaffold(state),
          );
        }
      },
    );
  }

  Widget _scaffold(state) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: state.isSearchGoing
          ? _searchAppBar(state)
          : state.isSelected
              ? _editingAppBar(
                  state,
                )
              : _defaultAppBar(
                  state,
                ),
      body: Stack(
        children: <Widget>[
          _eventMessagesList(
            state,
          ),
          _categories(
            state,
          ),
          _hashTags(state),
          _messageBottomBar(
            state,
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _editingAppBar(state) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(radiusValue),
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded),
        onPressed: () => BlocProvider.of<EventPageCubit>(context).unselect(),
      ),
      title: const Text(''),
      actions: [
        IconButton(
          icon: const Icon(Icons.check_rounded),
          onPressed: () => BlocProvider.of<EventPageCubit>(context).check(),
        ),
        IconButton(
          icon: const Icon(Icons.reply_rounded),
          onPressed: () => _choosePage(state),
        ),
        IconButton(
          icon: const Icon(Icons.delete_rounded),
          onPressed: () => BlocProvider.of<EventPageCubit>(context).delete(),
        ),
        IconButton(
          icon: const Icon(Icons.copy_rounded),
          onPressed: () => BlocProvider.of<EventPageCubit>(context).copy(),
        ),
        IconButton(
          icon: const Icon(Icons.edit_rounded),
          onPressed: () => _controller.text =
              BlocProvider.of<EventPageCubit>(context).edit(),
        ),
      ],
    );
  }

  PreferredSizeWidget _defaultAppBar(state) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(radiusValue),
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(''),
      actions: [
        IconButton(
          icon: !state.onlyMarked
              ? const Icon(Icons.bookmark_border_rounded)
              : const Icon(Icons.bookmark_rounded),
          onPressed: () =>
              BlocProvider.of<EventPageCubit>(context).showMarked(),
        ),
        IconButton(
          icon: const Icon(Icons.search_rounded),
          onPressed: () =>
              BlocProvider.of<EventPageCubit>(context).startSearching(),
        ),
      ],
    );
  }

  PreferredSizeWidget _searchAppBar(state) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(radiusValue),
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded),
        onPressed: () {
          BlocProvider.of<EventPageCubit>(context).endSearching();
          _searchController.clear();
        },
      ),
      title: const Text(''),
      actions: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(left: 40),
            child: TextField(
              controller: _searchController,
              onChanged: (text) => BlocProvider.of<EventPageCubit>(context)
                  .searchMessages(_searchController.text),
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(10),
                border: InputBorder.none,
                hintText: 'Search',
              ),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: _searchController.clear,
        ),
      ],
    );
  }

  Widget _messageBottomBar(state) {
    return Visibility(
      visible: !state.isSearchGoing,
      child: Align(
        alignment: Alignment.bottomLeft,
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(radiusValue),
          ),
          child: Container(
            height: 50,
            color: Theme.of(context).colorScheme.onPrimary,
            child: BlocBuilder<SettingsCubit, SettingsState>(
              builder: (blocContext, settingsState) {
                return Row(
                  children: [
                    Visibility(
                      visible: settingsState.isCategoryPanelVisible,
                      child: IconButton(
                        icon: const Icon(Icons.stars_rounded),
                        color: Theme.of(context).colorScheme.background,
                        onPressed: () {
                          BlocProvider.of<EventPageCubit>(context)
                              .openCategoryPanel();
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_a_photo_rounded),
                      color: Theme.of(context).colorScheme.background,
                      onPressed: () =>
                          BlocProvider.of<EventPageCubit>(context).addImage(),
                    ),
                    Visibility(
                      visible: settingsState.isCustomDateUsed,
                      child: IconButton(
                        icon: const Icon(Icons.date_range_rounded),
                        color: Theme.of(context).colorScheme.background,
                        onPressed: () {
                          _selectTime();
                          _selectDate(context);
                        },
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Visibility(
                            visible: state.isDateTimeSelected,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                Jiffy(
                                  BlocProvider.of<EventPageCubit>(context)
                                      .selectedDateTime(),
                                ).format('d/M/y h:mm a'),
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              onChanged: (text) =>
                                  BlocProvider.of<EventPageCubit>(context)
                                      .findHashtagMatches(text),
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.background,
                              ),
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.all(10),
                                border: InputBorder.none,
                                hintText: 'Enter event',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                        icon: const Icon(Icons.send_rounded),
                        color: Theme.of(context).colorScheme.background,
                        onPressed: () {
                          BlocProvider.of<EventPageCubit>(context)
                              .addMessage(_controller.text);
                          _controller.clear();
                        }),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _eventMessagesList(state) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 70),
      child: AnimationLimiter(
        child: ListView.separated(
          itemCount: state.messages.length + 1,
          separatorBuilder: (context, i) =>
              AnimationConfiguration.staggeredList(
            position: i,
            duration: const Duration(milliseconds: 500),
            child: SlideAnimation(
              verticalOffset: 20.0,
              child: FadeInAnimation(
                child: _message(i, state),
              ),
            ),
          ),
          itemBuilder: (context, i) {
            if (i < state.messages.length) {
              return AnimationConfiguration.staggeredList(
                position: i,
                duration: const Duration(milliseconds: 1000),
                child: SlideAnimation(
                  verticalOffset: 10.0,
                  child: FadeInAnimation(
                    child: _day(i, state),
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _day(i, state) {
    return Visibility(
      visible: BlocProvider.of<EventPageCubit>(context).isSeparatorVisible(i),
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (blocContext, settingsState) {
          return Align(
            alignment: settingsState.dateAlignment,
            child: Container(
              width: 100,
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.all(
                  Radius.circular(radiusValue),
                ),
              ),
              child: Text(
                Jiffy(state.messages[i].date).format('d/M/y'),
                style: TextStyle(
                    fontSize: settingsState.fontSize.toDouble() - 4,
                    color: Theme.of(context).colorScheme.onSurface),
                textAlign: TextAlign.center,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _message(int i, eventState) {
    return Dismissible(
      confirmDismiss: (direction) async {
        if (!eventState.isSelected) {
          if (direction == DismissDirection.startToEnd) {
            _controller.text = BlocProvider.of<EventPageCubit>(context).edit(i);
            return false;
          } else if (direction == DismissDirection.endToStart) {
            BlocProvider.of<EventPageCubit>(context).delete(i);
            return false;
          }
        }
      },
      background: const Align(
        alignment: Alignment.centerLeft,
        child: Icon(Icons.edit_rounded),
      ),
      secondaryBackground: const Align(
        alignment: Alignment.centerRight,
        child: Icon(Icons.delete_rounded),
      ),
      key: Key(i.toString()),
      child: GestureDetector(
        onTap: () => BlocProvider.of<EventPageCubit>(context).mark(i),
        onLongPress: () => BlocProvider.of<EventPageCubit>(context).select(i),
        child: BlocBuilder<SettingsCubit, SettingsState>(
          builder: (blocContext, settingsState) {
            return Align(
              alignment: settingsState.messageAlignment,
              child: Container(
                width: 250,
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: i == eventState.selectedMessageIndex &&
                          eventState.isSelected
                      ? Theme.of(context).colorScheme.surface
                      : Theme.of(context).colorScheme.onPrimary,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(radiusValue),
                  ),
                ),
                child: _messageContent(eventState, i),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _messageContent(state, i) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.only(right: 5),
                child: BlocBuilder<SettingsCubit, SettingsState>(
                  builder: (blocContext, state) {
                    return Icon(
                      BlocProvider.of<EventPageCubit>(context).labelIcon(
                        state.isCategoryPanelVisible,
                        i,
                      ),
                      size: 16,
                      color: Theme.of(context).colorScheme.onSurface,
                    );
                  },
                ),
              ),
              Text(
                Jiffy(state.messages[i].date).format('h:mm a'),
                style: TextStyle(
                  fontSize: BlocProvider.of<SettingsCubit>(context)
                          .state
                          .fontSize
                          .toDouble() -
                      4,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const Spacer(),
              Align(
                alignment: Alignment.centerRight,
                child: Row(
                  children: [
                    Icon(
                      Icons.check_rounded,
                      color: state.messages[i].isChecked
                          ? Theme.of(context).colorScheme.primaryVariant
                          : Colors.transparent,
                      size: 20,
                    ),
                    Icon(
                      Icons.book_rounded,
                      color: state.messages[i].isMarked
                          ? Theme.of(context).colorScheme.primaryVariant
                          : Colors.transparent,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Column(
          children: [
            Visibility(
              visible: state.messages[i].imagePath != '',
              child: Image.file(
                File(state.messages[i].imagePath),
                height: 300,
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 25),
              child: LinkifyText(
                state.messages[i].text,
                linkTypes: [LinkType.hashTag],
                textStyle: TextStyle(
                  color: Theme.of(context).colorScheme.background,
                ),
                linkStyle: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            )
          ],
        )
      ],
    );
  }

  Widget _hashTags(EventPageState state) {
    return Visibility(
      visible: state.isHashTagPanelVisible,
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: state.hashTags.length,
            itemBuilder: (context, i) {
              return Container(
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.all(10),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(radiusValue),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    color: Theme.of(context).colorScheme.onPrimary,
                    child: Text(
                      state.hashTags[i],
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.background,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _categories(EventPageState state) {
    return Visibility(
      visible: state.isLabelPanelOpened,
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          height: 140,
          color: Theme.of(context).colorScheme.onPrimary,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: state.labels.length,
            itemBuilder: (context, i) {
              return GestureDetector(
                onTap: () => BlocProvider.of<EventPageCubit>(context)
                    .chooseCategory(i, state.labels[i].icon),
                child: Container(
                  margin: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      ClipOval(
                        child: Container(
                          height: 50,
                          width: 50,
                          color: state.labels[i].icon == state.selectedLabelIcon
                              ? Theme.of(context).colorScheme.surface
                              : Colors.transparent,
                          child: Icon(state.labels[i].icon),
                        ),
                      ),
                      Text(state.labels[i].name),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Future _choosePage(state) {
    var _chosenPageIndex;
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
              'Select the page you want to migrate the selected event(s) to'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Container(
                height: 300,
                width: 300,
                child: ListView.builder(
                  itemCount: state.eventPages.length,
                  itemBuilder: (context, i) {
                    return RadioListTile(
                      title: Text(state.eventPages[i].name),
                      value: i,
                      groupValue: _chosenPageIndex,
                      onChanged: (index) =>
                          setState(() => _chosenPageIndex = index),
                    );
                  },
                ),
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                BlocProvider.of<EventPageCubit>(context).moveMessage(
                  state.eventPages[_chosenPageIndex].id,
                );
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _selectTime() async {
    final newTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    BlocProvider.of<EventPageCubit>(context).setTime(newTime);
  }

  void _selectDate(BuildContext context) async {
    final newDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2010),
      lastDate: DateTime(2025),
    );
    BlocProvider.of<EventPageCubit>(context).setDate(newDate);
  }
}
