import 'package:flutter/material.dart';
import 'entity/entities.dart' as entity;
import 'widgets/widgets.dart' as custom;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: ThemeUpdater(
        child: const _ItemsPage(),
        theme: entity.Theme.defaultOne(),
      ),
    );
  }
}

class ThemeUpdater extends StatefulWidget {
  final Widget child;
  final entity.Theme theme;

  const ThemeUpdater({Key? key, required this.child, required this.theme}) : super(key: key);

  @override
  _ThemeUpdaterState createState() => _ThemeUpdaterState();
}

class _ThemeUpdaterState extends State<ThemeUpdater> {
  @override
  Widget build(BuildContext context) {
    return ThemeInherited(
      child: widget.child,
      preset: widget.theme,
      onEdited: () => setState(() => widget.theme.changeTheme()),
    );
  }
}

class ThemeInherited extends InheritedWidget {
  final entity.Theme preset;
  final Function onEdited;

  ThemeInherited({
    required this.preset,
    required child,
    required this.onEdited,
  }) : super(child: child);

  void changeTheme() {
    //exit(0);
    onEdited();
  }

  @override
  bool updateShouldNotify(covariant ThemeInherited oldWidget) => true;

  static ThemeInherited? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ThemeInherited>();
}

class TabContrDecorator extends InheritedWidget {
  final Function() onEdited;

  TabContrDecorator({
    required this.onEdited,
    required child,
  }) : super(child: child);

  @override
  bool updateShouldNotify(covariant TabContrDecorator oldWidget) => false;

  static TabContrDecorator? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<TabContrDecorator>();
}

class _ItemsPage extends StatefulWidget {
  const _ItemsPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ItemsPageState();
}

class _ItemsPageState extends State<_ItemsPage> with SingleTickerProviderStateMixin {
  late final List<entity.Message> _pendingTasks;
  late final List<entity.Message> _upcomingEvents;
  late final List<entity.Message> _notes;
  late final List<entity.Topic> _topics;

  String _title = 'Main';
  late TabController _tabController;
  static const List<String> _tabTitles = ['Main', 'Tasks', 'Events', 'Notes'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() => setState(() => _title = _tabTitles[_tabController.index]));
    loadItems();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void loadItems() {
    entity.Topic.loadTopics();
    _pendingTasks = entity.Task.getFavouriteTasks();
    _upcomingEvents = entity.Event.getFavouriteEvents();
    _notes = entity.Note.getFavouriteNotes();
    _topics = entity.Topic.topics;
  }

  @override
  Widget build(BuildContext context) {
    final themeInherited = ThemeInherited.of(context)!;
    return TabContrDecorator(
      onEdited: () => setState(() => {}),
      child: DefaultTabController(
        length: 4,
        child: Scaffold(
          backgroundColor: themeInherited.preset.colors.backgroundColor,
          appBar: AppBar(
            backgroundColor: themeInherited.preset.colors.themeColor1,
            title: Text(_title),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.brightness_4_rounded),
                tooltip: 'Change theme',
                onPressed: themeInherited.changeTheme,
              ),
            ],
          ),
          bottomNavigationBar: TabBar(
            indicatorColor: themeInherited.preset.colors.underlineColor,
            indicatorWeight: 3,
            controller: _tabController,
            tabs: [
              Tab(
                icon: Icon(
                  Icons.amp_stories_rounded,
                  color: themeInherited.preset.colors.iconColor1,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.feed_rounded,
                  color: themeInherited.preset.colors.iconColor1,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.event_rounded,
                  color: themeInherited.preset.colors.iconColor1,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.drive_file_rename_outline,
                  color: themeInherited.preset.colors.iconColor1,
                ),
              ),
            ],
            labelColor: Theme.of(context).primaryColor,
            unselectedLabelColor: Colors.black38,
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              custom.ChatList(
                key: null,
                topics: _topics,
              ),
              _itemsList('Tasks', _pendingTasks),
              _itemsList('Events', _upcomingEvents),
              _itemsList('Notes', _notes),
            ],
          ),
          floatingActionButton: custom.AddingButton(
            key: const Key('MainButton'),
            firstIcon: const Icon(
              Icons.add,
              size: 30,
            ),
            secondIcon: const Icon(
              Icons.remove,
              size: 30,
            ),
            tabController: _tabController,
          ),
        ),
      ),
    );
  }

  Widget _itemsList(String title, List items) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Padding(
          child: Text(
            title,
            style: const TextStyle(fontSize: 20),
          ),
          padding: const EdgeInsets.only(top: 16.0),
        ),
        Expanded(
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Card(
                key: ValueKey(item.uuid),
                margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                child: Padding(
                  child: custom.ItemColumn(item),
                  padding: const EdgeInsets.all(8.0),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
