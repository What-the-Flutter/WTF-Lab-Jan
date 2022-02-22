import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:linkfy_text/linkfy_text.dart';
import 'package:lottie/lottie.dart';

import '/data/services/firebase_api.dart';
import '/screens/event_screen/event_screen_cubit.dart';
import '/screens/filter_screen/filter_screen.dart';
import '/screens/filter_screen/filter_screen_cubit.dart';
import '/screens/main_screen/main_screen_cubit.dart';
import '/screens/settings/settings_cubit.dart';
import '../../icons.dart';
import 'timeline_screen_cubit.dart';

class TimelineScreen extends StatefulWidget {
  TimelineScreen({Key? key}) : super(key: key);

  @override
  _TimelineScreenState createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen>
    with TickerProviderStateMixin {
  late final AnimationController _animController;

  @override
  void initState() {
    final _filterState = BlocProvider.of<FilterScreenCubit>(context).state;
    BlocProvider.of<TimelineScreenCubit>(context).fetchAllEventLists();
    if (_filterState.isFilterOn) {
      BlocProvider.of<TimelineScreenCubit>(context).filterEventList(
        _filterState.searchText,
        _filterState.filterChatList,
        _filterState.filterCategoryList,
      );
    }
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _animController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animController.reset();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimelineScreenCubit, TimelineScreenState>(
      builder: (context, state) {
        return Scaffold(
          appBar: state.selectedItemsCount == 0
              ? _unselectedAppBar(state)
              : _selectedAppBar(state),
          body: state.eventList.isEmpty
              ? _emptyEventList(state)
              : _eventListView(state),
          drawer: const Drawer(),
          bottomNavigationBar: _customBottomNavigationBar(),
          floatingActionButton: _customFloatingActionButton(),
        );
      },
    );
  }

  Widget _customFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FilterScreen(),
          ),
        );

        final _filterState = BlocProvider.of<FilterScreenCubit>(context).state;
        print(_filterState.isFilterOn);
        if (_filterState.isFilterOn) {
          BlocProvider.of<TimelineScreenCubit>(context).filterEventList(
            _filterState.searchText,
            _filterState.filterChatList,
            _filterState.filterCategoryList,
          );
        } else {
          BlocProvider.of<TimelineScreenCubit>(context).fetchAllEventLists();
        }
      },
      child: const Icon(Icons.filter_list),
      splashColor: Colors.transparent,
    );
  }

  PreferredSizeWidget _unselectedAppBar(TimelineScreenState state) {
    return AppBar(
      centerTitle: true,
      title: Center(
        child: Text(
          'Timeline',
          style: TextStyle(
              fontSize: BlocProvider.of<SettingsCubit>(context).state.fontSize),
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.search),
        ),
        _favoriteButton(state),
      ],
    );
  }

  PreferredSizeWidget _selectedAppBar(TimelineScreenState state) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () =>
            BlocProvider.of<TimelineScreenCubit>(context).unselectElements(),
      ),
      title: Text(
        '${state.selectedItemsCount}',
        style: TextStyle(
          fontSize: BlocProvider.of<SettingsCubit>(context).state.fontSize,
        ),
      ),
      actions: [
        IconButton(
          onPressed: _choosePage,
          icon: const Icon(Icons.reply),
        ),
        state.selectedItemsCount == 1
            ? IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {},
              )
            : Container(),
        IconButton(
          onPressed: () =>
              BlocProvider.of<TimelineScreenCubit>(context).copyText(),
          icon: const Icon(Icons.copy),
        ),
        IconButton(
          onPressed: () => BlocProvider.of<TimelineScreenCubit>(context)
              .addSelectedToFavorites(),
          icon: const Icon(Icons.bookmark_border),
        ),
        IconButton(
          onPressed: () =>
              BlocProvider.of<TimelineScreenCubit>(context).deleteElement(),
          icon: const Icon(Icons.delete),
        ),
      ],
    );
  }

  Future _choosePage() {
    var chosenIndex = 0;
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Select the page you want to migrate the selected event(s) to!',
            style: TextStyle(
              fontSize: BlocProvider.of<SettingsCubit>(context).state.fontSize,
            ),
          ),
          content: StatefulBuilder(builder: (context, setState) {
            return Container(
              height: 300,
              width: 300,
              child: ListView.builder(
                itemCount: BlocProvider.of<EventScreenCubit>(context)
                    .state
                    .chatList
                    .length,
                itemBuilder: (context, index) {
                  return RadioListTile(
                    title: Text(
                      BlocProvider.of<EventScreenCubit>(context)
                          .state
                          .chatList[index]
                          .elementName,
                      style: TextStyle(
                        fontSize: BlocProvider.of<SettingsCubit>(context)
                            .state
                            .fontSize,
                      ),
                    ),
                    value: index,
                    groupValue: chosenIndex,
                    onChanged: (index) {
                      setState(() => chosenIndex = index as int);
                    },
                  );
                },
              ),
            );
          }),
          actions: [
            TextButton(
              onPressed: () {
                BlocProvider.of<EventScreenCubit>(context)
                    .moveMessageToAnotherChat(chosenIndex);
                Navigator.pop(context);
              },
              child: Text(
                'Ok',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize:
                      BlocProvider.of<SettingsCubit>(context).state.fontSize,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  IconButton _favoriteButton(TimelineScreenState state) {
    return IconButton(
      onPressed: () =>
          BlocProvider.of<TimelineScreenCubit>(context).showFavorites(),
      icon: !state.isShowFavorites
          ? const Icon(Icons.bookmark_border)
          : const Icon(
              Icons.bookmark_outlined,
              color: Colors.yellow,
            ),
    );
  }

  Widget _emptyEventList(TimelineScreenState state) {
    final text = state.isShowFavorites
        ? "You don't have any bookmarked events, or none of the"
            'unfiltered pages have any bookmarked events'
        : 'There are no events to be displayed on your timeline,'
            'or you have filtered out all your pages in the filter menu.';

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 20),
                    margin: const EdgeInsets.only(left: 30, right: 30, top: 15),
                    color: Theme.of(context).colorScheme.primaryVariant,
                    child: Column(
                      children: [
                        Text(
                          'Your timeline is empty!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: BlocProvider.of<SettingsCubit>(context)
                                .state
                                .fontSize,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          text,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: BlocProvider.of<SettingsCubit>(context)
                                .state
                                .fontSize,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _eventListView(state) {
    final dateFormat = DateFormat('MMM dd, yyyy');

    return ListView.builder(
      reverse: true,
      itemCount: state.eventList.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            if (index == state.eventList.length - 1 ||
                dateFormat.format(state.eventList[index].date) !=
                    dateFormat.format(state.eventList[index + 1].date))
              _eventDate(
                state,
                index,
                dateFormat.format(state.eventList[index].date),
              ),
            _dismissibleEvent(state, index),
          ],
        );
      },
    );
  }

  Widget _eventDate(TimelineScreenState state, int index, String date) {
    return Column(
      children: [
        const SizedBox(height: 6),
        Align(
          alignment:
              BlocProvider.of<SettingsCubit>(context).state.isDateCenterAlign
                  ? Alignment.center
                  : Alignment.centerLeft,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            margin: const EdgeInsets.only(left: 10),
            decoration: BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              date,
              style: TextStyle(
                fontSize:
                    BlocProvider.of<SettingsCubit>(context).state.fontSize,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _dismissibleEvent(TimelineScreenState state, int index) {
    return GestureDetector(
      onTap: () => BlocProvider.of<TimelineScreenCubit>(context).onTap(index),
      onLongPress: () =>
          BlocProvider.of<TimelineScreenCubit>(context).onLongPress(index),
      child: Align(
        alignment:
            BlocProvider.of<SettingsCubit>(context).state.isBubbleChatleft
                ? Alignment.bottomLeft
                : Alignment.bottomRight,
        child: _event(state, index),
      ),
    );
  }

  Widget _event(TimelineScreenState state, int index) {
    final unselectedColor = Theme.of(context).colorScheme.primaryVariant;
    final selectedColor = Theme.of(context).colorScheme.secondaryVariant;
    final timeFormat = DateFormat('h:mm a');

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 369),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        padding: const EdgeInsets.only(right: 18, bottom: 6, top: 10, left: 8),
        decoration: BoxDecoration(
          color: state.eventList[index].isSelected
              ? selectedColor
              : unselectedColor,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              state.eventList[index].chatName,
              style: TextStyle(
                color: Colors.grey,
                fontSize:
                    BlocProvider.of<SettingsCubit>(context).state.fontSize,
              ),
            ),
            state.eventList[index].categoryIndex == 0
                ? Container(height: 0, width: 0)
                : Icon(categoriesMap.values
                    .elementAt(state.eventList[index].categoryIndex)),
            if (state.eventList[index].imagePath.isNotEmpty)
              _image(index, state)
            else
              LinkifyText(
                state.eventList[index].text,
                linkTypes: [LinkType.hashTag],
                textStyle: TextStyle(
                  fontSize:
                      BlocProvider.of<SettingsCubit>(context).state.fontSize,
                ),
                linkStyle: const TextStyle(color: Colors.blue),
                onTap: (link) => print(link.value),
              ),
            Padding(
              padding: const EdgeInsets.only(top: 3, left: 5),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (state.eventList[index].isSelected) _isSelectedItem(),
                  Text(
                    timeFormat.format(state.eventList[index].date).toString(),
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: BlocProvider.of<SettingsCubit>(context)
                          .state
                          .fontSize,
                    ),
                  ),
                  AnimatedOpacity(
                    opacity: state.eventList[index].isFavorite ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: _isFavoriteItem(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _isSelectedItem() {
    return Row(
      children: [
        Icon(
          Icons.check_circle,
          color: Theme.of(context).colorScheme.secondary,
          size: 15,
        ),
        const SizedBox(width: 6),
      ],
    );
  }

  Widget _isFavoriteItem() {
    return Row(
      children: [
        const Icon(
          Icons.bookmark,
          color: Colors.yellow,
          size: 15,
        ),
      ],
    );
  }

  Widget _image(int index, TimelineScreenState state) {
    return FutureBuilder(
      future: FirebaseApi.getFile('images/${state.eventList[index].imagePath}'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    _FullSizeImage(state.eventList[index].imagePath),
              ),
            ),
            child: Hero(
              tag: 'imageHero',
              child: Image.network(snapshot.data as String),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting ||
            !snapshot.hasData) {
          return LottieBuilder.asset(
            'assets/loader.json',
            repeat: true,
            controller: _animController,
            onLoaded: (composition) {
              _animController.forward();
            },
          );
        }
        return LottieBuilder.asset(
          'assets/loader.json',
          repeat: true,
          controller: _animController,
          onLoaded: (composition) {
            _animController.forward();
          },
        );
      },
    );
  }

  BottomNavigationBar _customBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: BlocProvider.of<MainScreenCubit>(context).state.selectedTab,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.book),
          label: 'Home',
          tooltip: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.assignment_rounded),
          label: 'Daily',
          tooltip: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          label: 'Timeline',
          tooltip: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.explore),
          label: 'Explore',
          tooltip: '',
        ),
      ],
      onTap: (index) =>
          BlocProvider.of<MainScreenCubit>(context).selectTab(index),
    );
  }
}

class _FullSizeImage extends StatelessWidget {
  final String imagePath;

  _FullSizeImage(this.imagePath);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseApi.getFile('images/$imagePath'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          return GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Hero(
              tag: 'imageHero',
              child: Image.network(snapshot.data.toString()),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting ||
            !snapshot.hasData) {
          const CircularProgressIndicator();
        }
        return Container();
      },
    );
  }
}
