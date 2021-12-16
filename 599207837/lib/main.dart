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
  final List<entity.Task> pendingTasks;
  final List<entity.Event> upcomingEvents;
  final List<entity.Note> notes;
  final Function() onEdited;

  TabContrDecorator(
      {required this.pendingTasks,
      required this.upcomingEvents,
      required this.notes,
      required this.onEdited,
      required child})
      : super(
          child: child,
        );

  @override
  bool updateShouldNotify(covariant TabContrDecorator oldWidget) {
    return false;
  }

  static TabContrDecorator? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<TabContrDecorator>();
}

class _ItemsPage extends StatefulWidget {
  const _ItemsPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ItemsPageState();
}

class _ItemsPageState extends State<_ItemsPage>
    with SingleTickerProviderStateMixin {
  late final List<entity.Task> pendingTasks;
  late final List<entity.Event> upcomingEvents;
  late final List<entity.Note> notes;

  String _title = 'Main';
  late TabController _tabController;
  static const List<String> tabTitles = ['Main', 'Tasks', 'Events', 'Notes'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() => _title = tabTitles[_tabController.index]);
    });
    loadItems();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void loadItems() {
    pendingTasks = entity.Task.getPendingTasks();
    upcomingEvents = entity.Event.getUpcomingEvents();
    notes = entity.Note.getNotes();
  }

  @override
  Widget build(BuildContext context) {
    return TabContrDecorator(
      pendingTasks: pendingTasks,
      upcomingEvents: upcomingEvents,
      notes: notes,
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
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content:
                          Text('You haven\'t received any notifications')));
                },
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
              const widget.ChatList(
                key: null,
              ),
              _itemsList('Tasks', pendingTasks),
              _itemsList('Events', upcomingEvents),
              _itemsList('Notes', notes),
            ],
          ),
          floatingActionButton: const widget.AddingButton(
              key: Key('MainButton'),
              firstIcon: Icon(Icons.add),
              secondIcon: Icon(Icons.remove)),
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
                margin: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 25.0),
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
