import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../messages/screen_messages_cubit.dart';
import '../settings/settings_page_cubit.dart';
import 'searching_messages_cubit.dart';

class SearchingPage extends StatelessWidget {
  static const routeName = '/SearchMsg';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: TextField(
            cursorColor: Theme.of(context).accentColor,
            controller: context.read<SearchMessageCubit>().controller,
            decoration: InputDecoration(
              hintText: 'Search',
              hintStyle: TextStyle(fontSize: 20, color: Colors.white),
              fillColor: Colors.white,
            ),
            style: TextStyle(color: Colors.white),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            context.read<SearchMessageCubit>().controller.clear();
            Navigator.pop(context);
          },
        ),
      ),
      body: _listFoundMessage(),
    );
  }

  Widget _listFoundMessage() {
    return Center(
      child: BlocBuilder<SearchMessageCubit, SearchMessageState>(
        builder: (context, state) {
          if (state is SearchMessageScreenWait) {
            return Container(
              padding: EdgeInsets.all(20),
              color: Colors.orange[50],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(
                    Icons.search,
                    size: 55,
                  ),
                  Text(
                    'Please enter a search query to begin searching',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            );
          } else if (state is SearchMessageScreenNotFound) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              padding: EdgeInsets.all(20),
              color: Colors.orange[50],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'No search results available',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Center(
                    child: Text(
                      'Please try again.',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return ListView.builder(
              itemCount: state.list.length,
              itemBuilder: (context, index) {
                return FoundMessage(
                  index: index,
                );
              },
            );
          }
        },
      ),
    );
  }
}

class FoundMessage extends StatelessWidget {
  final int index;

  const FoundMessage({Key key, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final data = context.read<SearchMessageCubit>().state.list[index];
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            border: Border.all(
              color: Colors.orange,
            ),
            color: Colors.orange[50],
          ),
          padding: EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                context.read<ScreenMessagesCubit>().state.page.title,
                style: TextStyle(
                  fontSize:
                      BlocProvider.of<SettingPageCubit>(context).state.fontSize,
                  color: Colors.black,
                ),
              ),
              data.message,
            ],
          ),
        ),
      ),
    );
  }
}
