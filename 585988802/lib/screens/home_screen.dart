import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../blocs/blocs.dart';
import '../db_helper/db_helper.dart';
import '../main.dart';
import '../models/app_tab.dart';
import '../models/event_message.dart';
import '../models/suggestion.dart';
import '../theme_provider/custom_theme_provider.dart';
import '../widgets/change_theme_button_widget.dart';
import '../widgets/custom_dialog.dart';
import '../widgets/info_about_suggestion_dialog.dart';
import '../widgets/tab_selector.dart';
import 'creating_categories_screen.dart';
import 'creating_suggestion_screen.dart';
import 'event_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

///This class implements the main logic of the [HomeScreen].
class _HomeScreenState extends State<HomeScreen> {
  // int _currentIndexBotNavBar = 0;
  final TextEditingController _textEditingController = TextEditingController();
  final DBHelper _dbHelper = DBHelper();

  Suggestion _selectedSuggestion;
  List<EventMessage> eventMessageList = [];

  @override
  void initState() {
    _dbHelper.initializeDatabase();
    _updateSuggestionList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _distributeEventMessagesToSuggestions();
    return BlocBuilder<TabBloc, AppTab>(
      builder: (context, activeTab) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: _appBar,
          drawer: _drawer,
          body: _homePageBody,
          bottomNavigationBar: TabSelector(
            activeTab: activeTab,
            onTabSelected: (tab) =>
                BlocProvider.of<TabBloc>(context).add(TabUpdated(tab)),
          ),
          floatingActionButton: _floatingActionButton,
        );
      },
    );
  }

  void _updateSuggestionList() {
    var dbSuggestionList = _dbHelper.dbSuggestionsList();
    dbSuggestionList.then((dbCurrentSuggestionList) {
      setState(() {
        suggestionsList = dbCurrentSuggestionList;
      });
    });
    var dbEventMessagesList = _dbHelper.dbEventMessagesList();
    dbEventMessagesList.then((dbCurrentEventMessageList) {
      setState(() {
        eventMessageList = dbCurrentEventMessageList;
      });
    });
  }

  void _distributeEventMessagesToSuggestions() {
    setState(() {
      for (var i = 0; i < suggestionsList.length; i++) {
        var localEventMessageList = <EventMessage>[];
        for (var j = 0; j < eventMessageList.length; j++) {
          if (eventMessageList[j].nameOfSuggestion ==
              suggestionsList[i].nameOfSuggestion) {
            localEventMessageList.insert(0, eventMessageList[j]);
          }
        }
        suggestionsList[i].eventMessagesList = localEventMessageList;
      }
    });
  }

  ///Builds AppBar for [HomeScreen].
  AppBar get _appBar {
    return AppBar(
      iconTheme: Theme.of(context).iconTheme,
      backgroundColor: Theme.of(context).appBarTheme.color,
      title: Container(
        child: Text(
          widget.title,
          style: TextStyle(
            color: Provider.of<ThemeProvider>(context).isDarkMode
                ? Theme.of(context).accentColor
                : Theme.of(context).primaryColor,
          ),
        ),
        alignment: Alignment.center,
      ),
      elevation: 0.0,
      actions: [
        ChangeThemeButtonWidget(),
      ],
    );
  }

  ///Builds Drawer.
  Drawer get _drawer {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: Provider.of<ThemeProvider>(context).isDarkMode
                    ? [Colors.deepPurpleAccent.shade200, Colors.purpleAccent]
                    : [Colors.deepOrangeAccent, Colors.red],
              ),
            ),
            accountName: Text(
              'Alex',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Provider.of<ThemeProvider>(context).isDarkMode
                    ? Theme.of(context).accentColor
                    : Theme.of(context).primaryColor,
              ),
            ),
            accountEmail: Text(
              'shevelyanchik01@mail.ru',
              style: TextStyle(
                color: Provider.of<ThemeProvider>(context).isDarkMode
                    ? Theme.of(context).accentColor
                    : Theme.of(context).primaryColor,
              ),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              foregroundColor: Theme.of(context).scaffoldBackgroundColor,
              child: Icon(
                Icons.person,
                size: 50,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text(
              'All Pages',
              style: TextStyle(
                color: Theme.of(context).accentColor,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.widgets_outlined),
            title: Text(
              'Categories',
              style: TextStyle(
                color: Theme.of(context).accentColor,
              ),
            ),
            onTap:  () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreatingCategoriesScreen(),
                ),
              );
              _updateSuggestionList();
            },
          ),
          ListTile(
            leading: Icon(Icons.timeline),
            title: Text(
              'Timeline',
              style: TextStyle(
                color: Theme.of(context).accentColor,
              ),
            ),
          ),
          ListTile(
            leading: Icon(CupertinoIcons.smiley),
            title: Text(
              'Daily',
              style: TextStyle(
                color: Theme.of(context).accentColor,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.tag),
            title: Text(
              'Tags',
              style: TextStyle(
                color: Theme.of(context).accentColor,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.assessment_outlined),
            title: Text(
              'Statistics',
              style: TextStyle(
                color: Theme.of(context).accentColor,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.search),
            title: Text(
              'Search',
              style: TextStyle(
                color: Theme.of(context).accentColor,
              ),
            ),
          ),
          Divider(
            color: Colors.black54,
            height: 0.5,
            thickness: 0.5,
            indent: 15,
            endIndent: 15,
          ),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text(
              'Notifications',
              style: TextStyle(
                color: Theme.of(context).accentColor,
              ),
            ),
          ),
          ListTile(
            leading: Icon(CupertinoIcons.circle_righthalf_fill),
            title: Text(
              'Change Theme',
              style: TextStyle(
                color: Theme.of(context).accentColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///Builds floatingActionButton to add a new event category.
  FloatingActionButton get _floatingActionButton {
    return FloatingActionButton(
      tooltip: 'New Suggestion',
      child: Icon(
        Icons.add,
        color: Theme.of(context).floatingActionButtonTheme.foregroundColor,
      ),
      backgroundColor:
          Theme.of(context).floatingActionButtonTheme.backgroundColor,
      hoverColor: Colors.orange,
      onPressed: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CreatingSuggestionScreen(
              suggestionsList: suggestionsList,
            ),
          ),
        );
        _updateSuggestionList();
      },
    );
  }

  Widget get _homePageBody {
    return _listViewSuggestions;
  }

  Widget get _listViewSuggestions {
    return BlocBuilder<SuggestionsBloc, SuggestionsState>(
      builder: (context, suggestion) {
        return ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.0),
            topRight: Radius.circular(25.0),
          ),
          child: Container(
            padding: EdgeInsets.only(left: 10.0, right: 10.0),
            decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25.0),
                topRight: Radius.circular(25.0),
              ),
            ),
            child: ListView.builder(
              reverse: false,
              itemCount: suggestionsList.length,
              itemBuilder: (context, index) {
                suggestionsList
                    .sort((a, b) => (a.isPinned).compareTo(b.isPinned));
                var _localSuggestionsList =
                    List<Suggestion>.from(suggestionsList.reversed);

                return _row(_localSuggestionsList, index);
              },
            ),
          ),
        );
      },
    );
  }

  ///Builds suggestion card.
  Widget _row(List<Suggestion> list, int index) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      color: Theme.of(context).cardColor,
      child: ListTile(
        leading: Image.asset(list[index].imagePathOfSuggestion),
        title: Text(
          list[index].nameOfSuggestion,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          list[index].eventMessagesList.isNotEmpty
              ? (list[index].eventMessagesList.first.isImageMessage == 1
                  ? 'Image'
                  : list[index].eventMessagesList.first.text)
              : list[index].infoOfSuggestion,
          maxLines: 1,
        ),
        trailing: list[index].isPinned == 1
            ? Transform.rotate(
                angle: 45 * pi / 180,
                child: Icon(
                  Icons.push_pin,
                  color: Theme.of(context).iconTheme.color,
                ),
              )
            : Icon(null),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventScreen(
                title: list[index].nameOfSuggestion,
                listViewSuggestion: list[index],
                suggestionsList: suggestionsList,
              ),
            ),
          );
          _updateSuggestionList();
        },
        onLongPress: () {
          setState(() => _showBottomSheet(context, list[index]));
        },
      ),
    );
  }

  void _showBottomSheet(BuildContext context, Suggestion listViewSuggestions) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        context: context,
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).bottomSheetTheme.backgroundColor,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(25.0),
                topLeft: Radius.circular(25.0),
              ),
            ),
            child: _structureBottomSheet(listViewSuggestions),
          );
        });
  }

  Column _structureBottomSheet(Suggestion listViewSuggestions) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Expanded(
          flex: 0,
          child: Padding(
            padding: EdgeInsets.only(top: 5.0),
            child: ListTile(
              leading: Image.asset(listViewSuggestions.imagePathOfSuggestion),
              title: Text(
                listViewSuggestions.nameOfSuggestion,
                maxLines: 2,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 25.0),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 0,
          child: _listTile(
            context,
            'Info',
            Icons.info_outline,
            _showInfoAboutSuggestion,
            null,
          ),
        ),
        Expanded(
          flex: 0,
          child: _listTile(
            context,
            listViewSuggestions.isPinned == 1
                ? 'Unpin suggestion'
                : 'Pin suggestion',
            Icons.push_pin,
            listViewSuggestions.isPinned == 1
                ? _unpinSuggestion
                : _pinSuggestion,
            null,
          ),
        ),
        Expanded(
          flex: 0,
          child: _listTile(
            context,
            'Edit',
            Icons.edit,
            _editSuggestion,
            listViewSuggestions,
          ),
        ),
        Expanded(
          flex: 0,
          child: _listTile(
            context,
            'Delete',
            Icons.delete,
            _deleteSuggestion,
            listViewSuggestions,
          ),
        ),
      ],
    );
  }

  ListTile _listTile(BuildContext context, String name, IconData icon,
      Function action, Suggestion listViewSuggestion) {
    _selectedSuggestion = listViewSuggestion;
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.white,
      ),
      title: Text(
        name,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        action();
      },
    );
  }

  Future<Object> _showInfoAboutSuggestion() {
    return showGeneralDialog(
      barrierDismissible: false,
      context: context,
      transitionDuration: Duration(milliseconds: 800),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: CurvedAnimation(
            parent: animation,
            curve: Curves.elasticOut,
            reverseCurve: Curves.easeOutCubic,
          ),
          child: InfoAboutSuggestionDialog(
            currentSuggestion: _selectedSuggestion,
          ),
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return null;
      },
    );
  }

  void _pinSuggestion() {
    setState(() {
      _selectedSuggestion.isPinned = 1;
      _dbHelper.updateSuggestion(_selectedSuggestion);
    });
  }

  void _unpinSuggestion() {
    setState(() {
      _selectedSuggestion.isPinned = 0;
      _dbHelper.updateSuggestion(_selectedSuggestion);
    });
  }

  void _editSuggestion() {
    setState(() {
      _showEditSuggestionCustomDialog(_selectedSuggestion);
    });
  }

  Future<Object> _showEditSuggestionCustomDialog(
      Suggestion listViewSuggestion) {
    _textEditingController.text = listViewSuggestion.nameOfSuggestion;
    return showGeneralDialog(
      barrierDismissible: false,
      context: context,
      transitionDuration: Duration(milliseconds: 800),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: CurvedAnimation(
            parent: animation,
            curve: Curves.elasticOut,
            reverseCurve: Curves.easeOutCubic,
          ),
          child: CustomDialog.editSuggestion(
            title: 'Edit the text',
            content: 'Edit your name of suggestion',
            firstBtnText: 'Cancel',
            secondBtnText: 'Save',
            icon: Icon(
              Icons.edit,
              color: Colors.white,
              size: 60,
            ),
            firstBtnFunc: _selectedCancel,
            secondBtnFunc: _selectedEdit,
            textEditControl: _textEditingController,
            nameOfSuggestion: _textEditingController.text,
          ),
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return null;
      },
    );
  }

  //temporary check of the function
  void _selectedCancel() => print('selected');

  void _selectedEdit() {
    setState(() {
      if (_textEditingController.text.isNotEmpty) {
        _selectedSuggestion.nameOfSuggestion = _textEditingController.text;
        _dbHelper.updateSuggestion(_selectedSuggestion);
        _updateSuggestionList();
        _textEditingController.clear();
      }
    });
  }

  void _deleteSuggestion() {
    // BlocProvider.of<SuggestionsBloc>(context)
    //     .add(SuggestionsDeleted(_selectedSuggestion));
    setState(() {
      _dbHelper.deleteSuggestion(_selectedSuggestion);
      _updateSuggestionList();
    });
  }
}
