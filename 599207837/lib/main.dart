import 'package:flutter/material.dart';
import 'entity/entities.dart' as entity;
import 'widgets/widgets.dart' as widget;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: _ItemsPage(),
    );
  }
}

class TabContrDecorator extends InheritedWidget {
  final Function() onEdited;

  TabContrDecorator({
    required this.onEdited,
    required child,
  }) : super(child: child);

  @override
  bool updateShouldNotify(covariant TabContrDecorator oldWidget) => false;

  static TabContrDecorator? of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<TabContrDecorator>();
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
    _pendingTasks = entity.Task.getFavouriteTasks();
    _upcomingEvents = entity.Event.getFavouriteEvents();
    _notes = entity.Note.getFavouriteNotes();
    entity.Topic.loadTopics();
  }

  @override
  Widget build(BuildContext context) {
    return TabContrDecorator(
      onEdited: () => setState(() => {}),
      child: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            title: Text(_title),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.add_alert),
                tooltip: 'Show notifications',
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('You haven\'t received any notifications'),
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(
                icon: Icon(Icons.amp_stories_rounded),
              ),
              Tab(
                icon: Icon(Icons.feed_rounded),
              ),
              Tab(
                icon: Icon(Icons.event_rounded),
              ),
              Tab(
                icon: Icon(Icons.drive_file_rename_outline),
              ),
            ],
            labelColor: Theme.of(context).primaryColor,
            unselectedLabelColor: Colors.black38,
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              const widget.ChatList(key: null),
              _itemsList('Tasks', _pendingTasks),
              _itemsList('Events', _upcomingEvents),
              _itemsList('Notes', _notes),
            ],
          ),
          floatingActionButton: widget.AddingButton(
            key: const Key('MainButton'),
            firstIcon: const Icon(Icons.add),
            secondIcon: const Icon(Icons.remove),
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
                  child: widget.ItemColumn(item),
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
