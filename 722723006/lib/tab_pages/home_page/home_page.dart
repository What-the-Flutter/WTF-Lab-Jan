import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../event_page/event_page.dart';
import '../../icon_list.dart';
import '../../note_page/note_page.dart';
import '../timeline_page/filter_page/filter_page_cubit.dart';
import 'home_page_cubit.dart';

class HomePageBody extends StatefulWidget {
  final String title;
  HomePageBody({Key key, this.title}) : super(key: key);

  @override
  _HomePageBodyState createState() => _HomePageBodyState();
}

class _HomePageBodyState extends State<HomePageBody> {
  @override
  void initState() {
    BlocProvider.of<HomePageCubit>(context).init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomePageCubit, HomePageStates>(
      builder: (context, state) {
        return Scaffold(
          body: _homePageBody(state),
          floatingActionButton: _floatingActionButton(state),
        );
      },
    );
  }

  ListView _homePageBody(HomePageStates state) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: state.noteList.length,
      itemBuilder: (context, index) => ListTile(
        title: Text(state.noteList[index].noteName),
        leading: IconButton(
          icon: CircleAvatar(
            child: listOfIcons[state.noteList[index].indexOfCircleAvatar],
          ),
          iconSize: 40,
          onPressed: () {},
        ),
        subtitle: Text(state.noteList[index].subTittleEvent),
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventPage(
                title: state.noteList[index].noteName,
                note: state.noteList[index],
                noteList: state.noteList,
              ),
            ),
          );
          BlocProvider.of<HomePageCubit>(context)
              .updateNote(state.noteList[index]);
        },
        onLongPress: () => _showBottomSheet(index, state),
      ),
    );
  }

  void _showBottomSheet(int index, HomePageStates state) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 170,
          child: _buildBottomNavigationMenu(index, state),
        );
      },
    );
  }

  Column _buildBottomNavigationMenu(int index, HomePageStates state) {
    return Column(
      children: <Widget>[
        ListTile(
          leading: Icon(
            Icons.info_outline,
            color: Colors.green[700],
          ),
          title: Text('Info'),
        ),
        ListTile(
          leading: Icon(
            Icons.edit,
            color: Colors.blue[700],
          ),
          title: Text('Edit'),
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NotePage(
                  note: state.noteList[index],
                ),
              ),
            );
            BlocProvider.of<HomePageCubit>(context)
                .updateNote(state.noteList[index]);
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: Icon(
            Icons.delete,
            color: Colors.red,
          ),
          title: Text('Delete'),
          onTap: () {
            BlocProvider.of<FilterPageCubit>(context).deleteNote(state.noteList[index]);
            BlocProvider.of<HomePageCubit>(context)
                .deleteNote(state.noteList, index);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  FloatingActionButton _floatingActionButton(HomePageStates state) {
    return FloatingActionButton(
      onPressed: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NotePage(
              noteList: state.noteList,
            ),
          ),
        );
        BlocProvider.of<HomePageCubit>(context).updateList(state.noteList);
      },
      child: Icon(Icons.add),
    );
  }
}
