import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../logic/screen_messages_cubit.dart';
import '../../repository/property_page.dart';
import '../theme/theme.dart';
import '../theme/theme_model.dart';


class ScreenMessage extends StatefulWidget {
  static const routeName = '/ScreenMsg';
  final PropertyPage _page;

  ScreenMessage(this._page);

  @override
  _ScreenMessageState createState() => _ScreenMessageState(_page);
}

class _ScreenMessageState extends State<ScreenMessage> {
  final PropertyPage _page;

  final _picker = ImagePicker();

  _ScreenMessageState(this._page);

  @override
  void dispose() {
    context.read<ScreenMessagesCubit>().controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScreenMessagesCubit, ScreenMessagesState>(
      builder: (context, state) {
        final messages = context.read<ScreenMessagesCubit>().messages;
        return Scaffold(
          appBar: state is ScreenMessagesInput
              ? _inputAppBar(state)
              : state is ScreenMessagesSelected
                  ? _selectionAppBar(state)
                  : _editAppBar(),
          body: Column(
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, i) {
                    if (state.isBookmarkMsg) {
                      if (messages[messages.length - i - 1].isFavor) {
                        return _buildItem(messages.length - i - 1, state);
                      } else {
                        return Container();
                      }
                    } else {
                      return _buildItem(messages.length - i - 1, state);
                    }
                  },
                ),
              ),
              _buildPanelInput(state),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPanelInput(ScreenMessagesState state) {
    return Padding(
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
              enabled:
                  state is ScreenMessagesInput || state is ScreenMessagesEdit
                      ? true
                      : false,
              controller: context.read<ScreenMessagesCubit>().controller,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: state is! ScreenMessagesEdit
                      ? Icon(Icons.arrow_forward_ios)
                      : Icon(Icons.check),
                  onPressed: state is! ScreenMessagesEdit
                      ?  () => context.read<ScreenMessagesCubit>().addMessage()
                      :  () => context.read<ScreenMessagesCubit>().updateMsg(),
                ),
                border: const OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: IconButton(
                icon: Icon(Icons.photo_camera),
                onPressed: null //_showPhotoLibrary,
                ),
          ),
        ],
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

  Widget _buildItem(int index, ScreenMessagesState state) {
    final msg = context.read<ScreenMessagesCubit>().messages[index];
    var color;
    if (Provider.of<ThemeModel>(context).currentTheme == darkTheme) {
      if (msg.isSelected) {
        color = Colors.orangeAccent;
      } else {
        color = Colors.black;
      }
    } else {
      if (msg.isSelected) {
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
          onTap: state is ScreenMessagesInput
              ? () => context
                  .read<ScreenMessagesCubit>()
                  .changeBookmarkMessage(index)
              : () => context
                  .read<ScreenMessagesCubit>()
                  .changeStateListItem(index),
          onLongPress: state is ScreenMessagesInput
              ? () => context.read<ScreenMessagesCubit>().changeState(index)
              : () => context
                  .read<ScreenMessagesCubit>()
                  .changeStateListItem(index),
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
                Text(msg.message),
                if (msg.isFavor)
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

  Widget _inputAppBar(ScreenMessagesState state) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.keyboard_backspace),
        onPressed: () {
          Navigator.pop(context, DateTime.now());
        },
      ),
      title: Center(
        child: Text(_page.title),
      ),
      actions: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: 20),
          child: Icon(Icons.search),
        ),
        Padding(
          padding: EdgeInsets.only(right: 20),
          child: IconButton(
            icon: state.isBookmarkMsg
                ? Icon(
                    Icons.bookmark,
                    color: Colors.orangeAccent,
                  )
                : Icon(Icons.bookmark_border),
            onPressed: () => context
                .read<ScreenMessagesCubit>()
                .changePresentationList(!state.isBookmarkMsg),
          ),
        ),
      ],
    );
  }

  Widget _editAppBar() {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.keyboard_backspace),
        onPressed: () => context.read<ScreenMessagesCubit>().resetMode(),
      ),
      title: Center(
        child: Text('Edit Mode'),
      ),
      actions: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: 15),
          child: IconButton(
              icon: Icon(Icons.close),
              onPressed: () =>
                  context.read<ScreenMessagesCubit>().changeMode()),
        ),
      ],
    );
  }

  Widget _selectionAppBar(ScreenMessagesState state) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.close),
        onPressed: () => context.read<ScreenMessagesCubit>().resetMode(),
      ),
      title: Text('${state.countDeletedMsg}'),
      actions: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: 10),
          child: IconButton(
            icon: Icon(Icons.share),
            onPressed: () {},
          ),
        ),
        if (state.countDeletedMsg < 2)
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () =>
                  context.read<ScreenMessagesCubit>().changeModeForEdit(),
            ),
          ),
        Padding(
          padding: EdgeInsets.only(right: 10),
          child: IconButton(
            icon: Icon(Icons.copy),
            onPressed: () => context.read<ScreenMessagesCubit>().createBuffer(),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: 10),
          child: IconButton(
            icon: Icon(Icons.bookmark_border),
            onPressed: () {},
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: 10),
          child: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () =>
                context.read<ScreenMessagesCubit>().removeMessages(),
          ),
        ),
      ],
    );
  }
}
