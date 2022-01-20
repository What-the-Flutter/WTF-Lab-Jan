import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '/models/chat_model.dart';
import 'add_new_chat_cubit.dart';

class AddNewChat extends StatefulWidget {
  const AddNewChat({Key? key}) : super(key: key);

  @override
  _AddNewChatState createState() => _AddNewChatState();
}

class _AddNewChatState extends State<AddNewChat> {
  final List<IconData> _iconsData = [
    Icons.text_fields,
    FontAwesomeIcons.userAstronaut,
    Icons.fitness_center,
    Icons.account_balance,
    Icons.fastfood,
    FontAwesomeIcons.donate,
    FontAwesomeIcons.wineGlassAlt,
    Icons.domain,
    Icons.account_balance_wallet,
    FontAwesomeIcons.dollarSign,
    Icons.shopping_cart,
    Icons.radio,
    Icons.videogame_asset,
    Icons.local_laundry_service,
    Icons.flag,
    Icons.music_note,
    FontAwesomeIcons.pills,
    Icons.event_seat,
    Icons.free_breakfast,
    Icons.pets,
    FontAwesomeIcons.lightbulb,
    Icons.star,
    FontAwesomeIcons.coins,
    Icons.pool,
    Icons.healing,
    Icons.nature_people,
    Icons.time_to_leave,
    FontAwesomeIcons.book,
    Icons.restaurant,
    Icons.cake,
    Icons.local_florist,
    FontAwesomeIcons.chessRook,
    Icons.weekend,
    Icons.vpn_key,
    FontAwesomeIcons.building,
    Icons.import_contacts,
    Icons.flight_takeoff,
    FontAwesomeIcons.basketballBall,
    Icons.access_time,
    FontAwesomeIcons.cookieBite,
    Icons.adjust,
    Icons.save,
    Icons.child_care,
    Icons.highlight,
  ];
  final _controller = TextEditingController();
  late final Chat? editingChat =
      ModalRoute.of(context)?.settings.arguments as Chat?;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddNewChatCubit, AddNewChatState>(
      builder: (context, state) {
        final _blocProvider = BlocProvider.of<AddNewChatCubit>(context);
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
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
                  const Text(
                    'Create a new Page',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _customTextField(_blocProvider, state),
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
      for (var i = 0; i < _iconsData.length - 1; i++) {
        if (_iconsData[i] == editingChat?.icon) {
          BlocProvider.of<AddNewChatCubit>(context)
              .initState(selectedIconIndex: i, isTextFieldEmpty: false);
          break;
        }
      }
    } else {
      BlocProvider.of<AddNewChatCubit>(context)
          .initState(selectedIconIndex: 0, isTextFieldEmpty: true);
    }
    super.didChangeDependencies();
  }

  Widget _customFloatingActionButton(
    AddNewChatCubit _blocProvider,
    AddNewChatState state,
  ) {
    return FloatingActionButton(
      onPressed: state.isTextFieldEmpty
          ? () => Navigator.pop(context)
          : () => _addNewChat(_blocProvider, state),
      child: state.isTextFieldEmpty
          ? const Icon(Icons.close)
          : const Icon(Icons.check),
      backgroundColor: const Color.fromRGBO(254, 215, 65, 1),
      foregroundColor: Colors.black,
      splashColor: Colors.transparent,
    );
  }

  Widget _customTextField(
    AddNewChatCubit _blocProvider,
    AddNewChatState state,
  ) {
    return TextField(
      controller: _controller,
      onChanged: (value) {
        if (_controller.text.isEmpty) {
          _blocProvider.isTextFieldEmpty(true);
        } else {
          _blocProvider.isTextFieldEmpty(false);
        }
      },
      autofocus: true,
      cursorColor: Colors.orange[400],
      decoration: InputDecoration(
        filled: true,
        fillColor: Theme.of(context).colorScheme.primaryVariant,
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
          style: TextStyle(color: Colors.orange[400]),
        ),
      ),
    );
  }

  Widget _customGridView(AddNewChatCubit _blocProvider, AddNewChatState state) {
    return GridView.builder(
      itemCount: _iconsData.length,
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
                    _iconsData[index],
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

  void _addNewChat(AddNewChatCubit _blocProvider, AddNewChatState state) {
    var date = DateTime.now();
    Chat _newChatElement;
    for (var i = 0; i < _iconsData.length - 1; i++) {
      if (state.selectedIconIndex == i) {
        if (editingChat == null) {
          _newChatElement = Chat(
            icon: _iconsData[i],
            elementName: _controller.text,
            creationDate: date,
            key: UniqueKey(),
            eventList: [],
          );
          Navigator.pop(context, _newChatElement);
        } else {
          Navigator.pop(
            context,
            editingChat?.copyWith(
              icon: _iconsData[i],
              elementName: _controller.text,
            ),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
