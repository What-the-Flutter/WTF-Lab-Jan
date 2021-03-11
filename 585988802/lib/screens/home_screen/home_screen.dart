import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common_widgets/change_theme_button_widget.dart';
import '../../common_widgets/custom_dialog.dart';
import '../../db_helper/db_helper.dart';
import '../../models/app_tab.dart';
import '../../models/font_size_customization.dart';
import '../../models/suggestion.dart';
import '../../theme/theme_bloc.dart';
import '../../theme/theme_event.dart';
import '../creating_categories_screen/creating_categories_screen.dart';
import '../creating_suggestion_screen/creating_suggestion_screen.dart';
import '../event_screen/event_screen.dart';
import '../setting_screen/setting_screen_event.dart';
import '../setting_screen/settings_screen.dart';
import '../setting_screen/settings_screen_bloc.dart';
import '../tab/tab_bloc.dart';
import '../tab/tab_event.dart';
import '../tab/tab_selector.dart';
import 'info_about_suggestion_dialog.dart';
import 'suggestions_bloc.dart';
import 'suggestions_event.dart';
import 'suggestions_state.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  final DBHelper _dbHelper = DBHelper();

  @override
  void initState() {
    BlocProvider.of<SuggestionsBloc>(context).add(SuggestionListInit());
    BlocProvider.of<ThemeBloc>(context).add(InitThemeEvent());
    BlocProvider.of<SettingScreenBloc>(context).add(InitSettingScreenEvent());
    _dbHelper.initializeDatabase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TabBloc, AppTab>(
      builder: (context, activeTab) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: _appBar,
          drawer: _drawer,
          body: _homePageBody(context),
          bottomNavigationBar: TabSelector(
            activeTab: activeTab,
            onTabSelected: (tab) => BlocProvider.of<TabBloc>(context).add(
              TabUpdated(tab),
            ),
          ),
          floatingActionButton: _floatingActionButton,
        );
      },
    );
  }

  AppBar get _appBar {
    return AppBar(
      iconTheme: Theme.of(context).iconTheme,
      backgroundColor: Theme.of(context).appBarTheme.color,
      title: Container(
        child: Text(
          widget.title,
          style: TextStyle(
            color: BlocProvider.of<ThemeBloc>(context).state == ThemeMode.dark
                ? Theme.of(context).accentColor
                : Theme.of(context).primaryColor,
            fontSize:
                BlocProvider.of<SettingScreenBloc>(context).state.fontSize == 0
                    ? appBarSmallFontSize
                    : BlocProvider.of<SettingScreenBloc>(context)
                                .state
                                .fontSize ==
                            1
                        ? appBarDefaultFontSize
                        : appBarLargeFontSize,
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
                colors: BlocProvider.of<ThemeBloc>(context).state ==
                        ThemeMode.dark
                    ? [Colors.deepPurpleAccent.shade200, Colors.purpleAccent]
                    : [Colors.deepOrangeAccent, Colors.red],
              ),
            ),
            accountName: Text(
              'Alex',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color:
                    BlocProvider.of<ThemeBloc>(context).state == ThemeMode.dark
                        ? Theme.of(context).accentColor
                        : Theme.of(context).primaryColor,
              ),
            ),
            accountEmail: Text(
              'shevelyanchik01@mail.ru',
              style: TextStyle(
                color:
                    BlocProvider.of<ThemeBloc>(context).state == ThemeMode.dark
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
            leading: Icon(Icons.search),
            title: Text(
              'Search',
              style: TextStyle(
                color: Theme.of(context).accentColor,
                fontSize: BlocProvider.of<SettingScreenBloc>(context)
                            .state
                            .fontSize ==
                        0
                    ? listTileTitleSmallFontSize
                    : BlocProvider.of<SettingScreenBloc>(context)
                                .state
                                .fontSize ==
                            1
                        ? listTileTitleDefaultFontSize
                        : listTileTitleLargeFontSize,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.widgets_outlined),
            title: Text(
              'Categories',
              style: TextStyle(
                color: Theme.of(context).accentColor,
                fontSize: BlocProvider.of<SettingScreenBloc>(context)
                            .state
                            .fontSize ==
                        0
                    ? listTileTitleSmallFontSize
                    : BlocProvider.of<SettingScreenBloc>(context)
                                .state
                                .fontSize ==
                            1
                        ? listTileTitleDefaultFontSize
                        : listTileTitleLargeFontSize,
              ),
            ),
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreatingCategoriesScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.timeline),
            title: Text(
              'Timeline',
              style: TextStyle(
                color: Theme.of(context).accentColor,
                fontSize: BlocProvider.of<SettingScreenBloc>(context)
                            .state
                            .fontSize ==
                        0
                    ? listTileTitleSmallFontSize
                    : BlocProvider.of<SettingScreenBloc>(context)
                                .state
                                .fontSize ==
                            1
                        ? listTileTitleDefaultFontSize
                        : listTileTitleLargeFontSize,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text(
              'Settings',
              style: TextStyle(
                color: Theme.of(context).accentColor,
                fontSize: BlocProvider.of<SettingScreenBloc>(context)
                            .state
                            .fontSize ==
                        0
                    ? listTileTitleSmallFontSize
                    : BlocProvider.of<SettingScreenBloc>(context)
                                .state
                                .fontSize ==
                            1
                        ? listTileTitleDefaultFontSize
                        : listTileTitleLargeFontSize,
              ),
            ),
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsScreen(),
                ),
              );
            },
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
                fontSize: BlocProvider.of<SettingScreenBloc>(context)
                            .state
                            .fontSize ==
                        0
                    ? listTileTitleSmallFontSize
                    : BlocProvider.of<SettingScreenBloc>(context)
                                .state
                                .fontSize ==
                            1
                        ? listTileTitleDefaultFontSize
                        : listTileTitleLargeFontSize,
              ),
            ),
          ),
        ],
      ),
    );
  }

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
        final createdSuggestion = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CreatingSuggestionScreen(),
          ),
        );
        BlocProvider.of<SuggestionsBloc>(context).add(
          SuggestionAdded(createdSuggestion),
        );
      },
    );
  }

  Widget _homePageBody(BuildContext context) {
    return BlocBuilder<SuggestionsBloc, SuggestionsState>(
      builder: (context, state) {
        BlocProvider.of<SuggestionsBloc>(context)
            .add(SuggestionEventMessageDistribute());
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
              itemCount: state.suggestionList.length,
              itemBuilder: (context, index) {
                BlocProvider.of<SuggestionsBloc>(context)
                    .add(SuggestionListSortByPinned(state.suggestionList));
                return _row(state.suggestionList, index, context);
              },
            ),
          ),
        );
      },
    );
  }

  Widget _row(List<Suggestion> list, int index, BuildContext context) {
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
          list[index].lastEventMessage != null
              ? (list[index].lastEventMessage.isImageMessage == 1
                  ? 'Image'
                  : list[index].lastEventMessage.text)
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
              builder: (context) {
                return EventScreen(
                  title: list[index].nameOfSuggestion,
                  listViewSuggestion: list[index],
                  suggestionsList: list,
                );
              },
            ),
          );
        },
        onLongPress: () {
          _showBottomSheet(context, list[index]);
        },
      ),
    );
  }

  void _showBottomSheet(BuildContext context, Suggestion selectedSuggestions) {
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
            child: _structureBottomSheet(selectedSuggestions, context),
          );
        });
  }

  Column _structureBottomSheet(
      Suggestion selectedSuggestions, BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Expanded(
          flex: 0,
          child: Padding(
            padding: EdgeInsets.only(top: 5.0),
            child: ListTile(
              leading: Image.asset(selectedSuggestions.imagePathOfSuggestion),
              title: Text(
                selectedSuggestions.nameOfSuggestion,
                maxLines: 2,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 25.0,
                ),
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
            selectedSuggestions,
          ),
        ),
        Expanded(
          flex: 0,
          child: _listTile(
            context,
            selectedSuggestions.isPinned == 1
                ? 'Unpin suggestion'
                : 'Pin suggestion',
            Icons.push_pin,
            selectedSuggestions.isPinned == 1
                ? _unpinSuggestion
                : _pinSuggestion,
            selectedSuggestions,
          ),
        ),
        Expanded(
          flex: 0,
          child: _listTile(
            context,
            'Edit',
            Icons.edit,
            _editSuggestion,
            selectedSuggestions,
          ),
        ),
        Expanded(
          flex: 0,
          child: _listTile(
            context,
            'Delete',
            Icons.delete,
            _deleteSuggestion,
            selectedSuggestions,
          ),
        ),
      ],
    );
  }

  ListTile _listTile(BuildContext context, String name, IconData icon,
      Function action, Suggestion selectedSuggestion) {
    BlocProvider.of<SuggestionsBloc>(context)
        .add(SuggestionSelected(selectedSuggestion));
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.white,
      ),
      title: Text(
        name,
        style: TextStyle(
          color: Colors.white,
          fontSize: BlocProvider.of<SettingScreenBloc>(context)
                      .state
                      .fontSize ==
                  0
              ? listTileTitleSmallFontSize
              : BlocProvider.of<SettingScreenBloc>(context).state.fontSize == 1
                  ? listTileTitleDefaultFontSize
                  : listTileTitleLargeFontSize,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        action(selectedSuggestion);
      },
    );
  }

  Future<Object> _showInfoAboutSuggestion(Suggestion selectedSuggestion) {
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
            selectedSuggestion: selectedSuggestion,
          ),
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return null;
      },
    );
  }

  void _pinSuggestion(Suggestion selectedSuggestion) {
    BlocProvider.of<SuggestionsBloc>(context).add(SuggestionPinned());
  }

  void _unpinSuggestion(Suggestion selectedSuggestion) {
    BlocProvider.of<SuggestionsBloc>(context).add(SuggestionUnpinned());
  }

  void _editSuggestion(Suggestion selectedSuggestion) {
    _showEditSuggestionCustomDialog(selectedSuggestion);
  }

  Future<Object> _showEditSuggestionCustomDialog(
      Suggestion selectedSuggestion) {
    _textEditingController.text = selectedSuggestion.nameOfSuggestion;
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

  void _selectedCancel() => print('selected');

  void _selectedEdit() {
    if (_textEditingController.text.isNotEmpty) {
      BlocProvider.of<SuggestionsBloc>(context).add(
        SuggestionEdited(_textEditingController.text),
      );
      _textEditingController.clear();
    }
  }

  void _deleteSuggestion(Suggestion selectedSuggestion) {
    BlocProvider.of<SuggestionsBloc>(context).add(SuggestionDeleted());
  }
}
