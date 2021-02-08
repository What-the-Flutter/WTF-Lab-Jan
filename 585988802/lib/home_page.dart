import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'change_theme_button_widget.dart';
import 'creating_suggestion.dart';
import 'custom_dialog.dart';
import 'custom_theme_provider.dart';
import 'event_page.dart';
import 'list_view_suggestions.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

///This class implements the main logic of the [HomePage].
class _HomePageState extends State<HomePage> {
  int _currentIndexBotNavBar = 0;
  ListViewSuggestions _bottomSheetSuggestions;
  final TextEditingController _textEditingController = TextEditingController();

  //Temporary list to test functionality.
  List<ListViewSuggestions> suggestionsList = [
    ListViewSuggestions(
        'Family', 'No Events. Click to create one.', 'assets/images/baby.png'),
    ListViewSuggestions(
        'Food', 'No Events. Click to create one.', 'assets/images/burger.png'),
    ListViewSuggestions(
        'Sport', 'No Events. Click to create one.', 'assets/images/gym.png'),
    ListViewSuggestions('Travel', 'No Events. Click to create one.',
        'assets/images/airplane.png'),
    ListViewSuggestions('Entertainment', 'No Events. Click to create one.',
        'assets/images/game_controller.png'),
    ListViewSuggestions('Study', 'No Events. Click to create one.',
        'assets/images/university.png'),
    ListViewSuggestions(
        'Work', 'No Events. Click to create one.', 'assets/images/work.png'),
    ListViewSuggestions('Supermarket', 'No Events. Click to create one.',
        'assets/images/supermarket.png'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _appBar(widget.title),
      drawer: drawer,
      body: _homePageBody(suggestionsList),
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
    );
  }

  ///Builds AppBar for [HomePage].
  AppBar _appBar(String title) {
    return AppBar(
      iconTheme: Theme.of(context).iconTheme,
      backgroundColor: Theme.of(context).appBarTheme.color,
      title: Container(
        child: Text(
          title,
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
  Drawer get drawer {
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
            leading: Icon(Icons.wb_sunny_outlined),
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
  FloatingActionButton get floatingActionButton {
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
            builder: (context) => CreatingPage(
              suggestionsList: suggestionsList,
            ),
          ),
        );
        setState(() {});
      },
    );
  }

  Widget _homePageBody(List list) {
    return Column(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: questionBotRaisedButton,
        ),
        Expanded(
          flex: 8,
          child: listViewSuggestions,
        ),
      ],
    );
  }

  Container get questionBotRaisedButton {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 7.0,
      ),
      child: RaisedButton.icon(
        label: Text(
          'Questionnaire Bot',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        textColor: Colors.black,
        splashColor: Colors.redAccent,
        icon: Icon(Icons.question_answer),
        color: Colors.orangeAccent,
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        onPressed: () {},
      ),
    );
  }

  ClipRRect get listViewSuggestions {
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
          itemCount: suggestionsList.length,
          itemBuilder: (context, index) {
            return _row(suggestionsList, index);
          },
        ),
      ),
    );
  }

  ///Builds suggestion card.
  Widget _row(List<ListViewSuggestions> list, int index) {
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
        subtitle: Text(list[index].infoOfSuggestion),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        onTap: () {
          setState(() {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EventPage(
                  title: list[index].nameOfSuggestion,
                ),
              ),
            );
          });
        },
        onLongPress: () {
          setState(() {
            _showBottomSheet(context, list[index]);
          });
        },
      ),
    );
  }

  void _showBottomSheet(
      BuildContext context, ListViewSuggestions listViewSuggestions) {
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

  Column _structureBottomSheet(ListViewSuggestions listViewSuggestions) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _listTile(
          context,
          'Info',
          Icons.info_outline,
          () {},
          null,
        ),
        _listTile(
          context,
          'Edit',
          Icons.edit,
          _editSuggestion,
          listViewSuggestions,
        ),
        _listTile(
          context,
          'Delete',
          Icons.delete,
          _deleteSuggestion,
          listViewSuggestions,
        ),
      ],
    );
  }

  ListTile _listTile(BuildContext context, String name, IconData icon,
      Function action, ListViewSuggestions listViewSuggestions) {
    _bottomSheetSuggestions = listViewSuggestions;
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

  void _editSuggestion() {
    setState(() {
      _showEditSuggestionCustomDialog(_bottomSheetSuggestions);
    });
  }

  Future<Object> _showEditSuggestionCustomDialog(
      ListViewSuggestions listViewSuggestions) {
    _textEditingController.text = listViewSuggestions.nameOfSuggestion;
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
            isEditMessage: true,
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
  void _selectedCancel() => print('Cancel');

  void _selectedEdit() {
    setState(() {
      if (_textEditingController.text.isNotEmpty) {
        var lastNameOfSuggestion = _bottomSheetSuggestions.nameOfSuggestion;
        var index = suggestionsList.indexOf(_bottomSheetSuggestions);
        suggestionsList[index].nameOfSuggestion = _textEditingController.text;
        for (var eventMessage in eventMessagesList) {
          if (eventMessage.nameOfSuggestion == lastNameOfSuggestion) {
            eventMessage.nameOfSuggestion = _textEditingController.text;
          }
        }
        _textEditingController.clear();
      }
    });
  }

  void _deleteSuggestion() {
    setState(() => suggestionsList.remove(_bottomSheetSuggestions));
  }

  BottomNavigationBar get bottomNavigationBar {
    return BottomNavigationBar(
      backgroundColor: Provider.of<ThemeProvider>(context).isDarkMode
          ? Theme.of(context).scaffoldBackgroundColor
          : Theme.of(context).primaryColor,
      currentIndex: _currentIndexBotNavBar,
      type: BottomNavigationBarType.fixed,
      fixedColor: Provider.of<ThemeProvider>(context).isDarkMode
          ? Theme.of(context).floatingActionButtonTheme.backgroundColor
          : Theme.of(context).scaffoldBackgroundColor,
      items: botNavBarItem,
      onTap: (index) {
        setState(() => _currentIndexBotNavBar = index);
      },
    );
  }

  ///Builds [BottomNavigationBarItem] elements.
  List<BottomNavigationBarItem> get botNavBarItem {
    return <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(
          Icons.home_sharp,
          color: Provider.of<ThemeProvider>(context).isDarkMode
              ? Theme.of(context).floatingActionButtonTheme.backgroundColor
              : Theme.of(context).scaffoldBackgroundColor,
        ),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Icon(
          Icons.assignment_outlined,
          color: Provider.of<ThemeProvider>(context).isDarkMode
              ? Theme.of(context).floatingActionButtonTheme.backgroundColor
              : Theme.of(context).scaffoldBackgroundColor,
        ),
        label: 'Daily',
      ),
      BottomNavigationBarItem(
        icon: Icon(
          Icons.timeline,
          color: Provider.of<ThemeProvider>(context).isDarkMode
              ? Theme.of(context).floatingActionButtonTheme.backgroundColor
              : Theme.of(context).scaffoldBackgroundColor,
        ),
        label: 'Timeline',
      ),
      BottomNavigationBarItem(
        icon: Icon(
          Icons.explore,
          color: Provider.of<ThemeProvider>(context).isDarkMode
              ? Theme.of(context).floatingActionButtonTheme.backgroundColor
              : Theme.of(context).scaffoldBackgroundColor,
        ),
        label: 'Explore',
      ),
    ];
  }
}
