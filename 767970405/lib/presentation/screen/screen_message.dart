import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../constants/enums.dart';
import '../../logic/screenMsgCubit/app_bar_cubit.dart';
import '../../logic/screenMsgCubit/counter_cubit.dart';
import '../../logic/screenMsgCubit/input_cubit.dart';
import '../../logic/screenMsgCubit/list_message_cubit.dart';
import '../../logic/screenMsgCubit/message_cubit.dart';
import '../../logic/screenMsgCubit/screen_messages_cubit.dart';
import '../../repository/property_message.dart';
import '../../repository/property_page.dart';
import '../theme/theme.dart';
import '../theme/theme_model.dart';

class ScreenMessage extends StatefulWidget {
  static const routeName = '/ScreenMsg';
  final PropertyPage page;

  ScreenMessage(this.page);

  @override
  _ScreenMessageState createState() => _ScreenMessageState();
}

class _ScreenMessageState extends State<ScreenMessage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ListMessageCubit>(
      create: (contextList) => ListMessageCubit(
        repository: contextList.read<ScreenMessagesCubit>().repository,
        list: context.read<ScreenMessagesCubit>().list,
      ),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<InputCubit>(
            create: (context) => InputCubit(),
          ),
          BlocProvider<CounterCubit>(
            create: (context) => CounterCubit(),
          ),
          BlocProvider<AppBarCubit>(
            create: (context) => AppBarCubit(
              title: widget.page.title,
              onBack: () => Navigator.pop(context),
              onChange: context.read<ListMessageCubit>().onChangeList,
            ),
          ),
        ],
        child: Scaffold(
          appBar: CustomAppBar(),
          body: Column(
            children: <Widget>[
              Expanded(
                child: BlocConsumer<ListMessageCubit, ListMessageState>(
                  listener: (context, state) {
                    context.read<ScreenMessagesCubit>().updateList();
                  },
                  builder: (context, state) => ListView.builder(
                    reverse: true,
                    itemCount: context
                        .read<ListMessageCubit>()
                        .repository
                        .messages
                        .length,
                    itemBuilder: (context, i) {
                      final messages =
                          context.read<ListMessageCubit>().repository.messages;

                      if (state.isBookmark &&
                          !messages[messages.length - i - 1].isFavor) {
                        return Container();
                      }
                      return Message(
                        message: messages[messages.length - i - 1],
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
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: BlocBuilder<InputCubit, InputState>(
        builder: (context, state) => Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Icon(Icons.bubble_chart),
            ),
            Expanded(
              flex: 5,
              child: TextField(
                enabled: state.isEditable,
                controller: context.read<InputCubit>().controller,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                icon: Icon(state.action.icon),
                onPressed: () {
                  var text = context.read<InputCubit>().controller.text;
                  context.read<InputCubit>().controller.text = '';
                  context.read<ListMessageCubit>().addMessage(text);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

// void _showPhotoLibrary() async {
//   final pickedFile = await _picker.getImage(source: ImageSource.gallery);
//
//   setState(() {
//     _messages.add(ListItem(pickedFile.path, isImage: true));
//   });
// }
}

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  CustomAppBar({Key key})
      : preferredSize = Size.fromHeight(kToolbarHeight),
        super(key: key);
  @override
  final Size preferredSize; // default is 56.0
  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppBarCubit, AppBarState>(
      listener: (context, state) {
        context.read<ScreenMessagesCubit>().updateOnTap(
              context.read<CounterCubit>().state.counter > 0 ? false : true,
            );
        context.read<InputCubit>().editable();
      },
      builder: (context, stateAppBar) => AppBar(
        leading: IconButton(
          icon: Icon(stateAppBar.leading.icon),
          onPressed: stateAppBar.leading.onTap,
        ),
        title: BlocConsumer<CounterCubit, CounterState>(
          listener: (context, state) {
            if (state.counter > 0) {
              context.read<AppBarCubit>().changeToSelection(
                    title: state.counter.toString(),
                    onClose: context.read<ScreenMessagesCubit>().unSelectionMsg,
                    onFavor: context.read<ScreenMessagesCubit>().makeFavor,
                    onCopy: context.read<ScreenMessagesCubit>().copy,
                    onDelete: context.read<ListMessageCubit>().remove,
                  );
            } else {
              context.read<AppBarCubit>().changeToInput(
                    title: context.read<ScreenMessagesCubit>().title,
                    onBack: () => Navigator.pop(context),
                    onChangeList: context.read<ListMessageCubit>().onChangeList,
                  );
            }
          },
          listenWhen: (prevState, curState) =>
              (prevState.counter == 0 && curState.counter == 1) ||
              (curState.counter == 0 && prevState.counter == 1),
          builder: (context, state) => Center(
            child: Text(stateAppBar.mode == ModeOperation.selection
                ? state.counter.toString()
                : stateAppBar.title),
          ),
        ),
        actions: [
          for (var i = 0; i < stateAppBar.actions.length; i++)
            Padding(
              padding: EdgeInsets.only(
                left: 10,
              ),
              child: IconButton(
                icon: Icon(stateAppBar.actions[i].icon),
                onPressed: stateAppBar.actions[i].onTap,
              ),
            )
        ],
      ),
    );
  }
}

class Message extends StatelessWidget {
  final PropertyMessage message;

  const Message({Key key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MessageCubit>(
      create: (context) {
        final cubit = MessageCubit(
          message: message.message,
          isFavor: message.isFavor,
        );
        context.read<ScreenMessagesCubit>().list.add(cubit);
        return cubit;
      },
      child: BlocConsumer<MessageCubit, MessageState>(
        listener: (context, state) {
          if (state.isSelected) {
            context.read<CounterCubit>().increment();
          } else if (context.read<CounterCubit>().state.counter != 0) {
            context.read<CounterCubit>().decrement();
          }
        },
        listenWhen: (prevState, curState) {
          if (prevState.isFavor != curState.isFavor) {
            return false;
          }
          if (prevState.onTap == null && curState.onTap != null ||
              prevState.onTap != null && curState.onTap == null) {
            return false;
          } else {
            return true;
          }
        },
        builder: (context, state) {
          var color;
          if (Provider.of<ThemeModel>(context).currentTheme == darkTheme) {
            if (state.isSelected) {
              color = Colors.orangeAccent;
            } else {
              color = Colors.black;
            }
          } else {
            if (state.isSelected) {
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
                onTap: state.onTap,
                onLongPress: context.read<MessageCubit>().selected,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: color,
                  ),
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      //if (msg.isImage) Image.file(File(msg.message)),
                      Text(state.message),
                      if (state.isFavor)
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
        },
      ),
    );
  }
}
