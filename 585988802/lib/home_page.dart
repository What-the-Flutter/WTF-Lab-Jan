import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'change_theme_button_widget.dart';
import 'creating_suggestion.dart';
import 'custom_dialog.dart';
import 'custom_theme_provider.dart';
import 'event_page.dart';
import 'info_about_suggestion_dialog.dart';
import 'list_view_suggestion.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

///This class implements the main logic of the [HomePage].
class _HomePageState extends State<HomePage> {
  int _currentIndexBotNavBar = 0;
  ListViewSuggestion _selectedSuggestion;
  final TextEditingController _textEditingController = TextEditingController();

  //Temporary list to test functionality.
  List<ListViewSuggestion> suggestionsList = [
    ListViewSuggestion('Family', 'assets/images/baby.png'),
    ListViewSuggestion('Food', 'assets/images/burger.png'),
    ListViewSuggestion('Sport', 'assets/images/gym.png'),
    ListViewSuggestion('Travel', 'assets/images/airplane.png'),
    ListViewSuggestion('Entertainment', 'assets/images/game_controller.png'),
    ListViewSuggestion('Study', 'assets/images/university.png'),
    ListViewSuggestion('Work', 'assets/images/work.png'),
    ListViewSuggestion('Supermarket', 'assets/images/supermarket.png'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _appBar,
      drawer: _drawer,
      body: _homePageBody,
      bottomNavigationBar: _bottomNavigationBar,
      floatingActionButton: _floatingActionButton,
    );
  }

  ///Builds AppBar for [HomePage].
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
            builder: (context) => CreatingPage(
              suggestionsList: suggestionsList,
            ),
          ),
        );
        setState(() {});
      },
    );
  }

  Column get _homePageBody {
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
          reverse: true,
          itemCount: suggestionsList.length,
          itemBuilder: (context, index) {
            suggestionsList.sort((a, b) => (a.isPinned).compareTo(b.isPinned));
            return _row(suggestionsList, index);
          },
        ),
      ),
    );
  }

  ///Builds suggestion card.
  Widget _row(List<ListViewSuggestion> list, int index) {
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
              ? (list[index].eventMessagesList.first.isImageMessage
                  ? 'Image'
                  : list[index].eventMessagesList.first.text)
              : list[index].infoOfSuggestion,
          maxLines: 1,
        ),
        trailing: list[index].isPinned == 1
            ? Icon(
                Icons.push_pin,
                color: Theme.of(context).iconTheme.color,
              )
            : Icon(null),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventPage(
                title: list[index].nameOfSuggestion,
                listViewSuggestion: list[index],
              ),
            ),
          );
          setState(() {});
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
      BuildContext context, ListViewSuggestion listViewSuggestions) {
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

  Column _structureBottomSheet(ListViewSuggestion listViewSuggestions) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 5.0),
          child: ListTile(
            leading: Image.asset(listViewSuggestions.imagePathOfSuggestion),
            title: Text(
              listViewSuggestions.nameOfSuggestion,
              maxLines: 4,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 25.0),
            ),
          ),
        ),
        _listTile(
          context,
          'Info',
          Icons.info_outline,
          _showInfoAboutSuggestion,
          null,
        ),
        _listTile(
          context,
          listViewSuggestions.isPinned == 1
              ? 'Unpin suggestion'
              : 'Pin suggestion',
          Icons.push_pin,
          listViewSuggestions.isPinned == 1 ? _unpinSuggestion : _pinSuggestion,
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
      Function action, ListViewSuggestion listViewSuggestion) {
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
    });
  }

  void _unpinSuggestion() {
    setState(() {
      _selectedSuggestion.isPinned = 0;
    });
  }

  void _editSuggestion() {
    setState(() {
      _showEditSuggestionCustomDialog(_selectedSuggestion);
    });
  }

  Future<Object> _showEditSuggestionCustomDialog(
      ListViewSuggestion listViewSuggestion) {
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
  void _selectedCancel() => print('selected');

  void _selectedEdit() {
    setState(() {
      if (_textEditingController.text.isNotEmpty) {
        var index = suggestionsList.indexOf(_selectedSuggestion);
        suggestionsList[index].nameOfSuggestion = _textEditingController.text;
        _textEditingController.clear();
      }
    });
  }

  void _deleteSuggestion() {
    setState(() => suggestionsList.remove(_selectedSuggestion));
  }

  BottomNavigationBar get _bottomNavigationBar {
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
