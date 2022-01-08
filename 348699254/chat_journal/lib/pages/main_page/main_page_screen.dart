import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:show_up_animation/show_up_animation.dart';
import 'package:splash_screen_view/SplashScreenView.dart';

import '../../auth/auth_cubit.dart';
import '../../data/data_provider/firebase_database_provider.dart';
import '../../data/data_provider/firebase_firestore_provider.dart';
import '../../data/data_provider/shared_preferences_provider.dart';
import '../../data/repository/event_repository.dart';
import '../../data/repository/page_repository.dart';
import '../../data/repository/settings_repository.dart';
import '../add_page/add_page_cubit.dart';
import '../add_page/add_page_screen.dart';
import '../event_page/event_cubit.dart';
import '../event_page/event_screen.dart';
import '../filters/filters_cubit.dart';
import '../settings/settings_cubit.dart';
import '../settings/settings_screen.dart';
import '../settings/settings_state.dart';
import '../timeline_page/timeline_cubit.dart';
import '../timeline_page/timeline_screen.dart';
import 'main_page_cubit.dart';
import 'main_page_state.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final firebaseDb = FirebaseDatabaseProvider();
  final firestoreDb = FirebaseFirestoreProvider();
  final pref = SharedPreferencesProvider();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ActivityPageRepository>(
          create: (context) => ActivityPageRepository(firebaseDb),
        ),
        RepositoryProvider<EventRepository>(
          create: (context) => EventRepository(firebaseDb, firestoreDb),
        ),
        RepositoryProvider<SettingsRepository>(
          create: (context) => SettingsRepository(pref),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthCubit(),
          ),
          BlocProvider(
            create: (context) => SettingsCubit(
              RepositoryProvider.of<SettingsRepository>(context),
            ),
          ),
          BlocProvider(
            create: (context) => EventCubit(
              RepositoryProvider.of<EventRepository>(context),
            ),
          ),
          BlocProvider(
            create: (context) => MainPageCubit(
              RepositoryProvider.of<ActivityPageRepository>(context),
            ),
          ),
          BlocProvider(
            create: (context) => TimelineCubit(
              RepositoryProvider.of<ActivityPageRepository>(context),
              RepositoryProvider.of<EventRepository>(context),
            ),
          ),
          BlocProvider(
            create: (context) => FiltersCubit(
              RepositoryProvider.of<ActivityPageRepository>(context),
              RepositoryProvider.of<EventRepository>(context),
            ),
          ),
          BlocProvider(
            create: (context) => AddPageCubit(
              RepositoryProvider.of<ActivityPageRepository>(context),
            ),
          ),
        ],
        child: BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, state) {
            return MaterialApp(
              title: 'Chat Journal App',
              themeMode: state.isLightTheme ? ThemeMode.dark : ThemeMode.dark,
              theme: state.themeData,
              initialRoute: '/',
              home: SplashScreenView(
                navigateRoute: MainPageScreen(),
                duration: 5000,
                imageSize: 300,
                imageSrc: 'assets/splash_screen.jpg',
                text: 'Chat Journal',
                textType: TextType.ColorizeAnimationText,
                textStyle: const TextStyle(
                  fontSize: 40.0,
                ),
                colors: [
                  Colors.purple,
                  Colors.blue,
                  Colors.yellow,
                  Colors.red,
                ],
                backgroundColor: Colors.white,
              ),
            );
          },
        ),
      ),
    );
  }
}

class MainPageScreen extends StatefulWidget {
  @override
  _MainPageScreenState createState() => _MainPageScreenState();
}

class _MainPageScreenState extends State<MainPageScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 4),
    vsync: this,
  )..forward();
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.fastOutSlowIn,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<AuthCubit>(context).signInAnonymously();
    authentication();
    BlocProvider.of<SettingsCubit>(context).initSettings();
    BlocProvider.of<MainPageCubit>(context).showActivityPages();
  }

  Future<void> authentication() async {
    if (await BlocProvider.of<SettingsCubit>(context)
        .isBiometricsAuthAbility()) {
      BlocProvider.of<AuthCubit>(context).authorizeWithBiometric();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainPageCubit, MainPageState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: _appBarHomeTitle(),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.wb_incandescent_outlined),
                onPressed: () =>
                    BlocProvider.of<SettingsCubit>(context).changeTheme(),
              ),
            ],
          ),
          drawer: _burgerMenuDrawer(),
          body: _bodyStructure(state),
          floatingActionButton: ScaleTransition(
            scale: _animation,
            child: FloatingActionButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddPageScreen(
                      isEditing: false,
                    ),
                  ),
                );
                BlocProvider.of<MainPageCubit>(context).showActivityPages();
              },
              child: const Icon(Icons.add),
            ),
          ),
          bottomNavigationBar: _bottomNavigationBar(),
        );
      },
    );
  }

  Widget _appBarHomeTitle() {
    return const Align(
      child: Text('Home'),
      alignment: Alignment.center,
    );
  }

  Drawer _burgerMenuDrawer() {
    return Drawer(
      child: ListView(
        children: <Widget>[
          const DrawerHeader(
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            child: UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Colors.teal),
              accountName: Text(''),
              accountEmail: Text('(Click here to setup Drive backups)'),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.card_giftcard_outlined),
            title: const Text('Help spread the world'),
            onTap: () => BlocProvider.of<SettingsCubit>(context).share(),
          ),
          ListTile(
            leading: const Icon(Icons.search),
            title: const Text('Search'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notifications'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.multiline_chart),
            title: const Text('Statistics'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.mail),
            title: const Text('Feedback'),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _bodyStructure(MainPageState state) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: _questionnaireBotContainer(),
            ),
          ],
        ),
        const Divider(height: 1),
        Expanded(
          child: _activityPageList(state, state.activityPageList),
        ),
      ],
    );
  }

  ListView _activityPageList(MainPageState state, List reversedList) {
    return ListView.separated(
      itemCount: reversedList.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) => Container(
        child: _listTileForActivity(
            state,
            reversedList[index].name,
            'No events. Click to create one',
            reversedList[index].iconIndex,
            index),
      ),
    );
  }

  final List<IconData> _iconData = const [
    Icons.airplane_ticket,
    Icons.weekend,
    Icons.sports_baseball_sharp,
    Icons.airplane_ticket,
    Icons.weekend,
    Icons.sports_baseball_sharp,
    Icons.airplane_ticket,
    Icons.weekend,
    Icons.sports_baseball_sharp,
    Icons.airplane_ticket,
    Icons.weekend,
    Icons.sports_baseball_sharp,
    Icons.airplane_ticket,
    Icons.weekend,
    Icons.sports_baseball_sharp,
    Icons.airplane_ticket,
    Icons.weekend,
    Icons.sports_baseball_sharp,
    Icons.airplane_ticket,
    Icons.weekend,
    Icons.sports_baseball_sharp,
    Icons.airplane_ticket,
    Icons.weekend,
    Icons.sports_baseball_sharp,
    Icons.airplane_ticket,
    Icons.weekend,
    Icons.sports_baseball_sharp,
  ];

  ListTile _listTileForActivity(MainPageState state, String title,
      String subtitle, int iconIndex, int index) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 20,
        ),
      ),
      subtitle: Text(
        subtitle,
      ),
      leading: _circleAvatarForActivityPage(state, iconIndex, index),
      onTap: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventScreen(
              activityPage: state.activityPageList[index],
              pageList: state.activityPageList,
            ),
          ),
        );
      },
      onLongPress: () => _onLongPagePress(state, index),
    );
  }

  CircleAvatar _circleAvatarForActivityPage(
      MainPageState state, int iconIndex, int index) {
    return CircleAvatar(
      backgroundColor: Colors.grey,
      radius: 30,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: IconButton(
              icon: Icon(_iconData[iconIndex]),
              iconSize: 30,
              color: Colors.white,
              onPressed: () {},
            ),
          ),
          if (state.activityPageList[index].isPinned)
            const Align(
              alignment: Alignment.bottomRight,
              child: CircleAvatar(
                radius: 10,
                backgroundColor: Colors.transparent,
                child: Icon(
                  Icons.push_pin,
                  color: Colors.black54,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _questionnaireBotContainer() {
    return FadeTransition(
      opacity: _animation,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(15),
          margin: const EdgeInsets.fromLTRB(20, 6, 20, 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.adb),
              const Text('   Questionnaire Bot'),
            ],
          ),
          decoration: BoxDecoration(
            color: Colors.blueGrey,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  void _onLongPagePress(MainPageState state, int index) {
    BlocProvider.of<MainPageCubit>(context).select(index);
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return ShowUpAnimation(
          animationDuration: const Duration(seconds: 2),
          curve: Curves.bounceIn,
          direction: Direction.vertical,
          offset: 0.2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      Card(
                        child: _listWithMenuOptions(state, index),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _listWithMenuOptions(MainPageState state, int index) {
    return ListView(
      shrinkWrap: true,
      children: [
        ListTile(
            title: const Text(
              'Info',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 20,
              ),
            ),
            leading: Icon(
              Icons.info,
              color: Colors.teal[500],
            ),
            onTap: () => _showInfoAboutPage(state, index)),
        ListTile(
          title: const Text(
            'Pin/Unpin Page',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 20,
            ),
          ),
          leading: Icon(
            Icons.push_pin,
            color: Colors.green[500],
          ),
          onTap: () => BlocProvider.of<MainPageCubit>(context).pinPage(),
        ),
        ListTile(
          title: const Text(
            'Archive Page',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 20,
            ),
          ),
          leading: Icon(
            Icons.archive_rounded,
            color: Colors.amber[500],
          ),
          onTap: () {},
        ),
        ListTile(
          title: const Text(
            'Edit Page',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 20,
            ),
          ),
          leading: const Icon(
            Icons.edit,
            color: Colors.blueAccent,
          ),
          onTap: () => _editActivityPage(index),
        ),
        ListTile(
          title: const Text(
            'Delete page',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 20,
            ),
          ),
          leading: Icon(
            Icons.delete,
            color: Colors.red[500],
          ),
          onTap: () => _alertDeleteDialog(index),
        ),
      ],
    );
  }

  Future<void> _editActivityPage(int index) async {
    BlocProvider.of<MainPageCubit>(context).select(index);
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddPageScreen(
          isEditing: true,
          selectedPageIndex: index,
        ),
      ),
    );
    BlocProvider.of<MainPageCubit>(context).showActivityPages();
  }

  void _showInfoAboutPage(MainPageState state, _selectedPageIndex) {
    var dialog = AlertDialog(
      title: ListTile(
        title: Text(
          state.activityPageList[_selectedPageIndex].name,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 20,
          ),
        ),
        leading: CircleAvatar(
          backgroundColor: Colors.grey,
          radius: 30,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: IconButton(
                  icon: Icon(state.activityPageList[_selectedPageIndex].icon),
                  iconSize: 30,
                  color: Colors.white,
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ),
      content: _infoDialogContent(state, _selectedPageIndex),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.indigoAccent,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3.0)),
          ),
          child: const Text(
            'Ok',
            style: TextStyle(
              color: Colors.black26,
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop(false); // Return true
          },
        ),
      ],
    );
    showDialog(
      context: context,
      builder: (context) {
        return dialog;
      },
    );
  }

  Widget _infoDialogContent(MainPageState state, _selectedPageIndex) {
    final dateFormat = DateFormat('dd/MM/yy');
    final timeFormat = DateFormat('h:m a');
    final dateInDataTime =
        DateTime.parse(state.activityPageList[_selectedPageIndex].creationDate);
    final timeInDataTime =
        DateTime.parse(state.activityPageList[_selectedPageIndex].creationDate);
    final dateInString = dateFormat.format(dateInDataTime);
    final timeInString = timeFormat.format(timeInDataTime);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(0),
          child: Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Column(
              children: <Widget>[
                _infoListTile('Created', '$dateInString at $timeInString'),
                _infoListTile('Latest Event', 'Today at...'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  ListTile _infoListTile(String title, String subtitle) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 20,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          color: Colors.black26,
        ),
      ),
    );
  }

  void _alertDeleteDialog(int pageIndex) {
    var dialog = AlertDialog(
      title: const Text('Delete Entry(s)?'),
      content: const FittedBox(
        child: Text('Are you sure you want to delete the 1 selected events?'),
      ),
      actions: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                BlocProvider.of<MainPageCubit>(context).deleteActivityPage();
                _deleteToast();
                Navigator.of(context).pop(true);
              },
            ),
            const Text('Delete'),
          ],
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.cancel, color: Colors.blue),
              onPressed: () {
                Navigator.of(context).pop(false); // Return true
              },
            ),
            const Text('Cancel'),
          ],
        ),
      ],
    );
    var futureValue = showDialog(
      context: context,
      builder: (context) {
        return dialog;
      },
    );
    futureValue.then(
      (value) {
        BlocProvider.of<MainPageCubit>(context).unselect();
      },
    );
  }

  Future<bool?> _deleteToast() {
    return Fluttertoast.showToast(
        msg: 'Delete selected event',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 16.0);
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
