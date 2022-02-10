import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/icons.dart';
import '/models/chat_model.dart';
import '../settings/settings_cubit.dart';
import 'add_new_chat_cubit.dart';

class AddNewChat extends StatefulWidget {
  final bool addCategory;

  const AddNewChat({
    Key? key,
    this.addCategory = false,
  }) : super(key: key);

  @override
  _AddNewChatState createState() => _AddNewChatState();
}

class _AddNewChatState extends State<AddNewChat> {
  final _controller = TextEditingController();
  late final Chat? editingChat =
      ModalRoute.of(context)?.settings.arguments as Chat?;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddNewChatCubit, AddNewChatState>(
      builder: (context, state) {
        final _blocProvider = BlocProvider.of<AddNewChatCubit>(context);
        return Scaffold(
          floatingActionButton:
              _customFloatingActionButton(_blocProvider, state),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 30,
                vertical: 20,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),
                  Text(
                    'Create a new Page',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: BlocProvider.of<SettingsCubit>(context)
                          .state
                          .fontSize,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _customTextField(_blocProvider),
                  Expanded(
                    child: _customGridView(_blocProvider, state),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void didChangeDependencies() {
    if (editingChat != null) {
      _controller.text = editingChat!.elementName;
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length),
      );
      for (var i = 0; i < iconsData.length - 1; i++) {
        if (i == editingChat?.iconIndex) {
          BlocProvider.of<AddNewChatCubit>(context)
              .init(selectedIconIndex: i, isTextFieldEmpty: false);
          break;
        }
      }
    } else {
      BlocProvider.of<AddNewChatCubit>(context)
          .init(selectedIconIndex: 0, isTextFieldEmpty: true);
    }
    super.didChangeDependencies();
  }

  Widget _customFloatingActionButton(
    AddNewChatCubit _blocProvider,
    AddNewChatState state,
  ) {
    return FloatingActionButton(
      onPressed: () => returnToMainScreen(_blocProvider, state),
      child: state.isTextFieldEmpty
          ? const Icon(Icons.close)
          : const Icon(Icons.check),
      backgroundColor: const Color.fromRGBO(254, 215, 65, 1),
      foregroundColor: Colors.black,
      splashColor: Colors.transparent,
    );
  }

  void returnToMainScreen(
    AddNewChatCubit _blocProvider,
    AddNewChatState state,
  ) {
    if (state.isTextFieldEmpty) {
      Navigator.pop(context);
    } else if (widget.addCategory) {
      _blocProvider.addCategory(_controller.text);
      Navigator.pop(context);
    } else {
      editingChat == null
          ? _blocProvider.addChat(_controller.text)
          : _blocProvider.editChat(editingChat as Chat, _controller.text);
      Navigator.pop(context);
    }
  }

  Widget _customTextField(AddNewChatCubit _blocProvider) {
    return TextField(
      controller: _controller,
      onChanged: (value) => _blocProvider.isTextFieldEmpty(value, _controller),
      autofocus: true,
      cursorColor: Colors.orange[400],
      decoration: InputDecoration(
        filled: true,
        enabledBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(0),
          borderSide: const BorderSide(style: BorderStyle.none),
        ),
        focusedBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(0),
          borderSide: const BorderSide(style: BorderStyle.none),
        ),
        label: Text(
          'Name of the Page',
          style: TextStyle(
            color: Colors.orange[400],
            fontSize: BlocProvider.of<SettingsCubit>(context).state.fontSize,
          ),
        ),
      ),
    );
  }

  Widget _customGridView(AddNewChatCubit _blocProvider, AddNewChatState state) {
    return GridView.builder(
      itemCount: iconsData.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
      ),
      itemBuilder: (context, index) {
        return Container(
          alignment: Alignment.topCenter,
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primary,
                radius: 24,
                child: IconButton(
                  onPressed: () => _blocProvider.selectIcon(index),
                  icon: Icon(
                    iconsData[index],
                    size: 29,
                  ),
                  splashColor: Colors.transparent,
                  color: Theme.of(context).colorScheme.surface,
                ),
              ),
              if (index == state.selectedIconIndex)
                CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  radius: 7,
                  child: Icon(
                    Icons.check_circle,
                    color: Colors.green[300],
                    size: 15,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
