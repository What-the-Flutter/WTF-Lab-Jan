import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hashtagable/widgets/hashtag_text.dart';
import 'package:intl/intl.dart';
import 'package:rive/rive.dart';

import '../filters/filters_screen.dart';
import '../main_page/main_page_screen.dart';
import '../settings/settings_cubit.dart';
import '../settings/settings_state.dart';
import 'timeline_cubit.dart';
import 'timeline_state.dart';

class TimelineScreen extends StatefulWidget {
  @override
  _TimelineScreenState createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen>
    with SingleTickerProviderStateMixin {
  final _eventInputController = TextEditingController();
  final timeFormat = DateFormat('h:m a');
  final Map<String, IconData> _categoriesMap = {
    'Cancel': Icons.cancel,
    'Workout': Icons.sports_tennis_rounded,
    'Movie': Icons.local_movies,
    'FastFood': Icons.fastfood,
    'Running': Icons.directions_run_outlined,
    'Sports': Icons.sports_baseball_rounded,
    'Laundry': Icons.local_laundry_service,
  };
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 1000),
    vsync: this,
  )..forward();
  late final Animation<Size> _myAnimation =
      Tween<Size>(begin: const Size(60, 60), end: const Size(80, 80)).animate(
          CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn));

  @override
  void initState() {
    super.initState();
    BlocProvider.of<TimelineCubit>(context).showAllEvents();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.repeat();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimelineCubit, TimelineState>(
      builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: _usualAppBar(state),
          body: state.isSearching && _eventInputController.text.isEmpty
              ? _startSearchContainer(state)
              : _bodyStructure(context, state),
          floatingActionButton: state.isSearching
              ? null
              : AnimatedBuilder(
                  animation: _myAnimation,
                  builder: (ctx, ch) => Container(
                    width: _myAnimation.value.width,
                    height: _myAnimation.value.height,
                    child: FloatingActionButton(
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FiltersScreen(),
                          ),
                        );
                        BlocProvider.of<TimelineCubit>(context)
                            .showFiltersEvents(result);
                      },
                      child: const Icon(Icons.sort),
                    ),
                  ),
                ),
          bottomNavigationBar: _bottomNavigationBar(),
        );
      },
    );
  }

  AppBar _usualAppBar(TimelineState state) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          if (state.isSearching) {
            BlocProvider.of<TimelineCubit>(context).finishSearching();
            BlocProvider.of<TimelineCubit>(context).showAllEvents();
            _eventInputController.clear();
          } else {
            Navigator.pop(context);
          }
        },
      ),
      title: Align(
        child: state.isSearching
            ? _textFormFieldForSearching(state)
            : const Text('Timeline'),
        alignment: Alignment.center,
      ),
      bottom: state.isSearching ? _hashtagList(state) : null,
      actions: state.isSearching
          ? <Widget>[
              if (_eventInputController.text.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.cancel_outlined),
                  onPressed: _eventInputController.clear,
                ),
            ]
          : <Widget>[
              _usualAppBarButtons(state),
            ],
    );
  }

  Widget _textFormFieldForSearching(TimelineState state) {
    return TextFormField(
      decoration: const InputDecoration(
        border: InputBorder.none,
        contentPadding: EdgeInsets.all(15),
        isDense: true,
        hintText: 'Search all pages',
        fillColor: Colors.teal,
        filled: true,
        hintStyle: TextStyle(
          color: Colors.grey,
        ),
      ),
      keyboardType: TextInputType.text,
      controller: _eventInputController,
      onChanged: (text) {
        BlocProvider.of<TimelineCubit>(context).showAllSearchedEvents(text);
      },
      onFieldSubmitted: (text) {
        BlocProvider.of<TimelineCubit>(context).showAllSearchedEvents(text);
      },
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _eventInputController.dispose();
    _controller.dispose();
    super.dispose();
  }

  PreferredSize _hashtagList(TimelineState state) {
    BlocProvider.of<TimelineCubit>(context).hashTagList();
    return PreferredSize(
      preferredSize: const Size.fromHeight(50),
      child: Expanded(
        child: ListView.builder(
          padding: const EdgeInsets.all(5),
          scrollDirection: Axis.horizontal,
          itemCount: state.hashtagList.length,
          itemBuilder: (_, index) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _hashtagItem(index, state),
            ],
          ),
        ),
      ),
    );
  }

  Widget _hashtagItem(int index, TimelineState state) {
    return FilterChip(
      backgroundColor: Colors.deepPurpleAccent,
      selectedColor: Colors.purpleAccent,
      label: Text(state.hashtagList[index]),
      selected: BlocProvider.of<TimelineCubit>(context)
          .isHashtagSelected(state.hashtagList[index]),
      onSelected: (selected) {
        BlocProvider.of<TimelineCubit>(context)
            .onHashtagSelected(state.hashtagList[index]);
      },
    );
  }

  Widget _startSearchContainer(TimelineState state) {
    return Align(
      alignment: AlignmentDirectional.topCenter,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
        margin: const EdgeInsets.fromLTRB(25, 50, 25, 0),
        child: const RiveAnimation.asset(
          'assets/search_icon.riv',
        ),
      ),
    );
  }

  Widget _usualAppBarButtons(TimelineState state) {
    return Row(
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () =>
              BlocProvider.of<TimelineCubit>(context).startSearching(),
        ),
        IconButton(
          icon: const Icon(Icons.bookmark_border_outlined),
          color: Colors.amber,
          onPressed: () => BlocProvider.of<TimelineCubit>(context)
              .showMarkedEvents(!state.isAllMarked),
        ),
      ],
    );
  }

  Widget _bodyStructure(BuildContext context, TimelineState state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Expanded(
          child: _timelineList(state),
        ),
      ],
    );
  }

  Widget _timelineList(TimelineState state) {
    return ListView.builder(
      padding: const EdgeInsets.all(5),
      reverse: true,
      itemCount: state.timelineList.length,
      itemBuilder: (_, index) {
        return Dismissible(
          key: UniqueKey(),
          background: Container(
            alignment: AlignmentDirectional.centerEnd,
            child: const Padding(
              padding: EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 0.0),
              child: Icon(
                Icons.delete,
                color: Colors.blueGrey,
              ),
            ),
          ),
          child: _timelineItem(index, state),
        );
      },
    );
  }

  Widget _timelineItem(int index, TimelineState state) {
    final timeFormat = DateFormat('h:m a');
    final timeInString =
        timeFormat.format(state.timelineList[index].creationDate);
    return Align(
      alignment: Alignment.centerLeft,
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (blocContext, settingsState) {
          final alignment = settingsState.isRightBubbleAlignment
              ? MainAxisAlignment.start
              : MainAxisAlignment.end;
          return Flex(
            direction: Axis.horizontal,
            mainAxisAlignment: alignment,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 5),
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.87),
                decoration: const BoxDecoration(
                  color: Colors.greenAccent,
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
                child: _timelineTile(
                  state,
                  state.timelineList[index].imagePath,
                  state.timelineList[index].eventData,
                  timeInString,
                  index,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _categoryContainer(int? categoryIconIndex, String? categoryName) {
    var entries = _categoriesMap.entries.toList();
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Icon(
            entries.elementAt(categoryIconIndex!).value,
            size: 35,
            color: Colors.black54,
          ),
          Text(
            '     ${categoryName!}',
            style: const TextStyle(
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _timelineTile(TimelineState state, String imagePath,
      String eventContent, String subtitle, int index) {
    return ListTile(
        title: imagePath.isNotEmpty
            ? Image.file(File(imagePath))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  if (state.timelineList[index].categoryIcon != null)
                    _categoryContainer(
                      state.timelineList[index].categoryIcon,
                      state.timelineList[index].categoryName,
                    ),
                  HashTagText(
                    text: eventContent,
                    decoratedStyle: const TextStyle(
                      fontSize: 16,
                      color: Colors.purple,
                    ),
                    basicStyle: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
        subtitle: Row(
          children: <Widget>[
            _listTileRow(subtitle),
          ],
        ),
        trailing: state.timelineList[index].isMarked
            ? const Icon(Icons.bookmark, color: Colors.amber)
            : null,
        onTap: () => BlocProvider.of<TimelineCubit>(context).markEvent(index),
        onLongPress: () {});
  }

  Widget _listTileRow(String subtitle) {
    return Row(
      children: <Widget>[
        Text(
          subtitle,
          style: const TextStyle(
            color: Colors.black26,
          ),
        ),
      ],
    );
  }

  Widget _listTileWithMarkIcon(String subtitle) {
    return Row(
      children: <Widget>[
        const Icon(
          Icons.bookmark,
          color: Colors.amber,
          size: 13,
        ),
        Text(
          subtitle,
          style: const TextStyle(
            color: Colors.black26,
          ),
        ),
      ],
    );
  }

  BottomNavigationBar _bottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      onTap: _selectedPage,
      items: [
        const BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: ('Home'),
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.assignment),
          label: ('Daily'),
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.exposure),
          label: ('Timeline'),
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.api),
          label: ('Explore'),
        )
      ],
    );
  }

  void _selectedPage(int index) {
    final pages = [
      MainPageScreen(),
      MainPageScreen(),
      TimelineScreen(),
      MainPageScreen(),
    ];
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => pages[index]));
  }
}
