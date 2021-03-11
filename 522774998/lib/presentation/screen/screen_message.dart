import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../enums/enums.dart';
import '../../../logic/home_screen_cubit.dart';
import '../../../logic/screenMessagesCubits/screen_messages_cubit.dart';
import '../../../repository/model/category_model.dart';
import '../../../repository/property_message.dart';
import '../../../repository/property_page.dart';
import '../../logic/screenMessagesCubits/app_bar_cubit.dart';
import '../../logic/screenMessagesCubits/counter_cubit.dart';
import '../../logic/screenMessagesCubits/input_cubit.dart';
import '../../logic/screenMessagesCubits/list_message_cubit.dart';
import '../../logic/screenMessagesCubits/message_cubit.dart';
import '../theme/theme.dart';
import '../theme/theme_model.dart';
import 'searhing_page.dart';

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
              onSearch: () => Navigator.pushNamed(
                context,
                SearchingPage.routeName,
                arguments: context.read<ScreenMessagesCubit>().repository,
              ),
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
                      return Message(
                        message: messages[messages.length - i - 1],
                      );
                    },
                  ),
                ),
              ),
              if (isVisibleCategories) _categoryLine(),
              _panelInput(),
            ],
          ),
        ),
      ),
    );
  }

  final List<CategoryIcon> listIconCategory = <CategoryIcon>[
    CategoryIcon(icon: Icons.sports_baseball, title: 'Sport'),
    CategoryIcon(icon: Icons.local_movies, title: 'Movie'),
    CategoryIcon(icon: Icons.music_note, title: 'Music'),
    CategoryIcon(icon: Icons.fastfood, title: 'Fastfood'),
    CategoryIcon(icon: Icons.local_laundry_service, title: 'Laundry'),
    CategoryIcon(icon: Icons.directions_run, title: 'Running'),
  ];
  bool isVisibleCategories = false;
  IconData categoryIcon = Icons.bubble_chart;

  Widget _categoryLine() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: BlocBuilder<InputCubit, InputState>(
        builder: (context, stateInput) => Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Column(
                children: <Widget>[
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.red,
                    child: IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        isVisibleCategories = !isVisibleCategories;
                        setState(() {});
                        categoryIcon = Icons.bubble_chart;
                      },
                    ),
                  ),
                  Text(
                    'Cancel',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 5,
              child: Container(
                height: 60,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: List.generate(
                    6,
                    (index) {
                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          children: <Widget>[
                            CircleAvatar(
                              backgroundColor: Theme.of(context).accentColor,
                              child: IconButton(
                                icon: Icon(
                                  listIconCategory[index].icon,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  categoryIcon = listIconCategory[index].icon;
                                  setState(() {});
                                },
                              ),
                            ),
                            Text(
                              listIconCategory[index].title,
                              style: TextStyle(color: Colors.black),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _category(IconData iconCategory, String categoryName) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: BlocBuilder<InputCubit, InputState>(
        builder: (context, stateInput) => Column(
          children: <Widget>[
            CircleAvatar(
              backgroundColor: Theme.of(context).accentColor,
              child: Icon(
                iconCategory,
                color: Colors.white,
              ),
            ),
            Text(
              categoryName,
            )
          ],
        ),
      ),
    );
  }

  Widget _panelInput() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: BlocBuilder<InputCubit, InputState>(
        builder: (context, stateInput) => Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: IconButton(
                icon: Icon(
                  categoryIcon,
                ),
                onPressed: () {
                  isVisibleCategories = !isVisibleCategories;
                  setState(() {});
                },
              ),
            ),
            Expanded(
              flex: 5,
              child: TextField(
                controller: context.read<InputCubit>().controller,
                decoration: InputDecoration(
                  hintText: 'Enter event',
                  suffixIcon: stateInput.mode == Operation.edit
                      ? IconButton(
                          icon: Icon(Icons.done),
                          onPressed: () {
                            var text =
                                context.read<InputCubit>().controller.text;
                            context.read<InputCubit>().controller.text = '';
                            context
                                .read<ListMessageCubit>()
                                .updateMessage(text);
                            //stateInput.mode = Operation.input;
                          },
                        )
                      : IconButton(
                          icon: Icon(stateInput.action.icon),
                          onPressed: () {
                            var text =
                                context.read<InputCubit>().controller.text;
                            context.read<InputCubit>().controller.text = '';
                            if (categoryIcon == Icons.bubble_chart) {
                              context.read<ListMessageCubit>().addMessage(text);
                            } else {
                              for (var i = 0;
                                  i < listIconCategory.length;
                                  i++) {
                                if (listIconCategory[i].icon == categoryIcon) {
                                  context
                                      .read<ListMessageCubit>()
                                      .addCategoryMessage(
                                          text,
                                          listIconCategory[i].title,
                                          categoryIcon);
                                }
                              }
                            }
                          },
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  CustomAppBar({Key key})
      : preferredSize = Size.fromHeight(kToolbarHeight),
        super(key: key);
  @override
  final Size preferredSize;

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
      },
      builder: (context, stateAppBar) => AppBar(
        leading: IconButton(
          icon: Icon(stateAppBar.leading.icon),
          onPressed: stateAppBar.leading.onTap,
        ),
        title: BlocConsumer<CounterCubit, CounterState>(
          listener: (context, state) {
            if (state.counter > 1) {
              context.read<AppBarCubit>().changeToSelection(
                    title: state.counter.toString(),
                    onClose: context.read<ScreenMessagesCubit>().unSelectionMsg,
                    onCopy: context.read<ScreenMessagesCubit>().copy,
                    onDelete: context.read<ListMessageCubit>().removeMessage,
                  );
            } else if (state.counter == 1) {
              context.read<AppBarCubit>().changeToEdition(
                    title: state.counter.toString(),
                    onClose: context.read<ScreenMessagesCubit>().unSelectionMsg,
                    onCopy: context.read<ScreenMessagesCubit>().copy,
                    onDelete: context.read<ListMessageCubit>().removeMessage,
                    onEdit: () {
                      context
                          .read<ScreenMessagesCubit>()
                          .edit(context.read<InputCubit>().controller);
                      //stateAppBar.mode = Operation.edit;
                      context
                          .read<ScreenMessagesCubit>()
                          .update(context.read<InputCubit>().controller);
                    },
                    onShare: () {
                      showDialog<void>(
                        context: context,
                        builder: (contextDialog) {
                          var selectedRadio = contextDialog
                              .read<HomePageCubit>()
                              .repository
                              .dialogPages[0]
                              .title;
                          return AlertDialog(
                            content: StatefulBuilder(
                              builder: (contextAlertDialog, setState) {
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: List<Widget>.generate(
                                    contextAlertDialog
                                        .read<HomePageCubit>()
                                        .repository
                                        .dialogPages
                                        .length,
                                    (index) {
                                      return Row(
                                        children: [
                                          Radio<String>(
                                            value: contextAlertDialog
                                                .read<HomePageCubit>()
                                                .repository
                                                .dialogPages[index]
                                                .title,
                                            groupValue: selectedRadio,
                                            onChanged: (value) {
                                              setState(
                                                  () => selectedRadio = value);
                                            },
                                          ),
                                          Text(contextAlertDialog
                                              .read<HomePageCubit>()
                                              .repository
                                              .dialogPages[index]
                                              .title),
                                        ],
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                            actions: <Widget>[
                              OutlinedButton(
                                onPressed: () => Navigator.pop(contextDialog),
                                child: Center(
                                  child: Text('Cancel'),
                                ),
                              ),
                              OutlinedButton(
                                onPressed: () {
                                  context
                                      .read<ListMessageCubit>()
                                      .moveMessageAnotherDialog(
                                          selectedRadio,
                                          context
                                              .read<HomePageCubit>()
                                              .repository
                                              .dialogPages);
                                  context
                                      .read<ListMessageCubit>()
                                      .removeMessage();
                                  context
                                      .read<ScreenMessagesCubit>()
                                      .unSelectionMsg();
                                  Navigator.pop(contextDialog);
                                },
                                child: Center(
                                  child: Text('Choose'),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
            } else {
              context.read<AppBarCubit>().changeToInput(
                    title: context.read<ScreenMessagesCubit>().title,
                    onBack: () => Navigator.pop(context),
                    onSearch: () => Navigator.pushNamed(
                      context,
                      SearchingPage.routeName,
                      arguments: context.read<ScreenMessagesCubit>().repository,
                    ),
                  );
            }
          },
          builder: (context, state) => Center(
            child: Text(
              stateAppBar.mode == Operation.selection
                  ? state.counter.toString()
                  : stateAppBar.title,
              style: TextStyle(fontSize: 24),
            ),
          ),
        ),
        actions: [
          for (var i = 0; i < stateAppBar.actions.length; i++)
            Padding(
              padding: EdgeInsets.only(
                left: 0,
              ),
              child: IconButton(
                icon: Icon(stateAppBar.actions[i].icon, color: Colors.white),
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
          icon: message.icon,
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
          if (prevState.onTap == null && curState.onTap != null ||
              prevState.onTap != null && curState.onTap == null) {
            return false;
          } else {
            return true;
          }
        },
        builder: (context, state) {
          if (Provider.of<ThemeModel>(context).currentTheme == darkTheme) {
            if (state.isSelected) {
            } else {}
          } else {
            if (state.isSelected) {
            } else {}
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
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                    border: Border.all(
                      color: state.isSelected
                          ? Provider.of<ThemeModel>(context)
                              .currentTheme
                              .primaryColor
                          : Colors.orange,
                    ),
                    color: state.isSelected
                        ? Provider.of<ThemeModel>(context)
                            .currentTheme
                            .backgroundColor
                        : Colors.orange[50],
                  ),
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      if (state.icon != null) Icon(state.icon),
                      Text(
                        state.message,
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
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
