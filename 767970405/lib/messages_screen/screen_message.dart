import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../data/model/model_page.dart';
import '../data/theme/theme.dart';
import '../data/theme/theme_model.dart';
import 'screen_message_cubit.dart';

class ScreenMessage extends StatefulWidget {
  static const routeName = '/ScreenMsg';
  final ModelPage page;

  ScreenMessage(this.page);

  @override
  _ScreenMessageState createState() => _ScreenMessageState();
}

class _ScreenMessageState extends State<ScreenMessage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ScreenMessageCubit(
        repository: widget.page.messages,
        title: widget.page.title,
        appBar: InputAppBar(title: widget.page.title),
      ),
      child: Builder(
        builder: (context) => Scaffold(
          appBar: PreferredSize(
            child: BlocBuilder<ScreenMessageCubit, ScreenMessageState>(
              builder: (context, state) => state.appBar,
            ),
            preferredSize: Size.fromHeight(56),
          ),
          body: Column(
            children: <Widget>[
              Expanded(
                child: BlocBuilder<ScreenMessageCubit, ScreenMessageState>(
                  builder: (context, state) => ListView.builder(
                    reverse: true,
                    itemCount: state.list.length,
                    itemBuilder: (context, i) {
                      if (state.isBookmark &&
                          !state.list[state.list.length - i - 1].isFavor) {
                        return Container();
                      }
                      return Message(
                        index: state.list.length - i - 1,
                      );
                    },
                  ),
                ),
              ),
              _buildPanelInput(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPanelInput() {
    return BlocBuilder<ScreenMessageCubit, ScreenMessageState>(
      builder: (context, state) => Padding(
        padding: EdgeInsets.symmetric(vertical: 5.0),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Icon(Icons.bubble_chart),
            ),
            Expanded(
              flex: 5,
              child: TextField(
                autofocus: true,
                enabled: state.enabledController,
                controller: context.read<ScreenMessageCubit>().controller,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                icon: Icon(state.iconData),
                onPressed: state.onAddMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InputAppBar extends StatelessWidget {
  final String title;

  const InputAppBar({
    Key key,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<ScreenMessageCubit, ScreenMessageState>(
      listener: (context, state) =>
          context.read<ScreenMessageCubit>().toSelectionAppBar(),
      listenWhen: (prevState, curState) =>
          prevState.counter == 0 && curState.counter == 1 ? true : false,
      child: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(title),
        actions: [
          Padding(
            padding: EdgeInsets.only(
              left: 10,
            ),
            child: IconButton(
              icon: Icon(Icons.search),
              onPressed: null,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 10,
            ),
            child: IconButton(
              icon: Icon(Icons.bookmark_border),
              onPressed: context.read<ScreenMessageCubit>().showBookmarkMessage,
            ),
          ),
        ],
      ),
    );
  }
}

class SelectionAppBar extends StatelessWidget {
  final String title;

  const SelectionAppBar({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<ScreenMessageCubit, ScreenMessageState>(
      listener: (context, state) => context
          .read<ScreenMessageCubit>()
          .toInputAppBar(context.read<ScreenMessageCubit>().title),
      listenWhen: (prevState, curState) =>
          prevState.counter >= 1 && curState.counter == 0 ? true : false,
      child: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: context.read<ScreenMessageCubit>().backToInputAppBar,
        ),
        title: BlocBuilder<ScreenMessageCubit, ScreenMessageState>(
          builder: (context, state) => Text(
            state.counter.toString(),
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: IconButton(
              icon: Icon(Icons.share),
              onPressed: null,
            ),
          ),
          BlocBuilder<ScreenMessageCubit, ScreenMessageState>(
            builder: (context, state) => state.counter == 1
                ? Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed:
                          context.read<ScreenMessageCubit>().toEditAppBar,
                    ),
                  )
                : Container(),
          ),
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: IconButton(
              icon: Icon(Icons.copy),
              onPressed: context.read<ScreenMessageCubit>().copy,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: IconButton(
              icon: Icon(Icons.bookmark_border),
              onPressed: context.read<ScreenMessageCubit>().makeFavor,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: IconButton(
              icon: Icon(Icons.delete),
              onPressed: context.read<ScreenMessageCubit>().delete,
            ),
          ),
        ],
      ),
    );
  }
}

class EditAppBar extends StatelessWidget {
  final String title;

  const EditAppBar({
    Key key,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.keyboard_backspace),
        onPressed: context.read<ScreenMessageCubit>().backToInputAppBar,
      ),
      title: Center(
        child: Text(title),
      ),
      actions: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: 15),
          child: IconButton(
            icon: Icon(Icons.close),
            onPressed: context.read<ScreenMessageCubit>().backToInputAppBar,
          ),
        ),
      ],
    );
  }
}

class Message extends StatelessWidget {
  final int index;

  const Message({Key key, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var color;
    if (Provider.of<ThemeModel>(context).currentTheme == darkTheme) {
      if (context.read<ScreenMessageCubit>().state.list[index].isSelected) {
        color = Colors.orangeAccent;
      } else {
        color = Colors.black;
      }
    } else {
      if (context.read<ScreenMessageCubit>().state.list[index].isSelected) {
        color = Colors.green[200];
      } else {
        color = Colors.green[50];
      }
    }
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: GestureDetector(
          onTap:
              context.read<ScreenMessageCubit>().state is ScreenMessageSelection
                  ? () => context.read<ScreenMessageCubit>().selection(index)
                  : null,
          onLongPress: () =>
              context.read<ScreenMessageCubit>().selection(index),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: color,
            ),
            padding: EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                context.read<ScreenMessageCubit>().state.list[index].message,
                if (context
                    .read<ScreenMessageCubit>()
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
      ),
    );
  }
}
