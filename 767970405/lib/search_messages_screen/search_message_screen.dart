import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_chat_journal/data/model/model_page.dart';

import '../data/repository/messages_repository.dart';
import '../messages_screen/screen_message.dart';
import '../messages_screen/screen_message_cubit.dart';
import 'search_message_screen_cubit.dart';

class SearchMessageScreen extends StatelessWidget {
  static const routeName = '/SearchMsg';
  final ModelPage page;

  const SearchMessageScreen({Key key, this.page})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchMessageScreenCubit(
        //repository: page.repository,
      ),
      child: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            title: TextField(
              autofocus: true,
              controller: context.read<SearchMessageScreenCubit>().controller,
              decoration: InputDecoration(
                labelText: 'Search in ${page.title}',
                labelStyle: TextStyle(
                  color: Colors.orange,
                ),
              ),
            ),
            actions: <Widget>[
              BlocBuilder<SearchMessageScreenCubit, SearchMessageScreenState>(
                builder: (context, state) => state is! SearchMessageScreenWait
                    ? IconButton(
                        icon: Icon(Icons.close),
                        onPressed: context
                            .read<SearchMessageScreenCubit>()
                            .resetController,
                      )
                    : Container(),
              )
            ],
          ),
          body: Center(
            child:
                BlocBuilder<SearchMessageScreenCubit, SearchMessageScreenState>(
              builder: (context, state) {
                if (state is SearchMessageScreenWait) {
                  return Container(
                    padding: EdgeInsets.all(20),
                    color: Colors.green[50],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(
                          Icons.search,
                          size: 55,
                        ),
                        Text('Please enter a search query to begin searching'),
                      ],
                    ),
                  );
                } else if (state is SearchMessageScreenNotFound) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    padding: EdgeInsets.all(20),
                    color: Colors.green[50],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          'No search results available',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Center(
                          child: Text('No entries math the given'
                              ' search query. Please try again.'),
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
          ),
        ),
      ),
    );
  }
}

class FoundMessage extends StatelessWidget {
  final int index;

  const FoundMessage({Key key, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: Colors.green[50],
          ),
          padding: EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text('Title'),
              context
                  .read<SearchMessageScreenCubit>()
                  .state
                  .list[index]
                  .message,
              if (context
                  .read<SearchMessageScreenCubit>()
                  .state
                  .list[index]
                  .isFavor)
                Icon(
                  Icons.bookmark,
                  color: Colors.orangeAccent,
                  size: 8,
                )
            ],
          ),
        ),
      ),
    );
  }
}

class DataForNavigation {
  final MessagesRepository repository;
  final String title;

  DataForNavigation({this.repository, this.title});
}
