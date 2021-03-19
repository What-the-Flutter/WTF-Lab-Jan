import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../repository/messages_repository.dart';
import '../messages/widgets/input/input_cubit.dart';
import '../messages/widgets/list_message/list_message_cubit.dart';

bool isSearching = false;

class SearchingPage extends StatefulWidget {
  static const routeName = '/SearchMsg';
  final MessagesRepository repositoryMessages;

  SearchingPage(this.repositoryMessages);

  @override
  _SearchingPageState createState() => _SearchingPageState();
}

class _SearchingPageState extends State<SearchingPage> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<InputCubit>(
          create: (context) => InputCubit(),
        ),
      ],
      child: Scaffold(
        appBar: _searchingAppBar,
        body: Column(
          children: <Widget>[],
        ),
      ),
    );
  }

  AppBar get _searchingAppBar {
    return AppBar(
      title: Container(
        alignment: Alignment.center,
        child: _buildPanelInput(),
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildPanelInput() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: BlocBuilder<InputCubit, InputState>(
        builder: (context, stateInput) => Row(
          children: <Widget>[
            Expanded(
              flex: 5,
              child: TextField(
                cursorColor: Theme.of(context).accentColor,
                controller: context.read<InputCubit>().controller,
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: TextStyle(fontSize: 20, color: Colors.white),
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      context.read<ListMessageCubit>().addSearchingMessage(
                          context.read<InputCubit>().controller);
                      isSearching = true;
                    },
                  ),
                ),
                style: TextStyle(color: Colors.white),
              ),
            ),
            Expanded(
              flex: 1,
              child: context.read<InputCubit>().controller.text == ''
                  ? SizedBox()
                  : IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        context.read<InputCubit>().controller.text = '';
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
