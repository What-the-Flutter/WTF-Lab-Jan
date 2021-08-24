import 'package:chat_journal/main.dart';
import 'package:chat_journal/pages/create_page/create_page.dart';
import 'package:chat_journal/pages/events_page/event_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'home_page_cubit.dart';

class HomePage extends StatefulWidget {
  final String? title;
  HomePage({Key? key, this.title}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    BlocProvider.of<HomePageCubit>(context).init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomePageCubit, HomePageState>(
      builder: (context, state) {
        return Scaffold(
          body: _homePageBody(state),
          floatingActionButton: _floatingActionButton(state),
        );
      },
    );
  }

  ListView _homePageBody(HomePageState state) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: state.noteList.length,
      itemBuilder: (context, index) => ListTile(
        title: Text(state.noteList[index].noteName),
        leading: IconButton(
          icon: CircleAvatar(
            child: Icon(iconsList[state.noteList[index].indexOfCircleAvatar]),
          ),
          iconSize: 40,
          onPressed: () {},
        ),
        subtitle: Text(state.noteList[index].subTitleEvent),
        onTap: () async {
          print('test');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventPage(
                title: state.noteList[index].noteName,
                note: state.noteList[index],
                noteList: state.noteList,
              ),
            ),
          );
        },
        onLongPress: () => _showBottomSheet(index, state),
      ),
    );
  }

  void _showBottomSheet(int index, HomePageState state) {
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

  Column _buildBottomNavigationMenu(int index, HomePageState state) {
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
            BlocProvider.of<HomePageCubit>(context)
                .deleteNote(state.noteList, index);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  FloatingActionButton _floatingActionButton(HomePageState state) {
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
