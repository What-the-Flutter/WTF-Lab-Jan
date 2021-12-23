import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/page_model.dart';
import '../home/page_qubit.dart';
import 'note_input.dart';
import 'note_qubit.dart';
import 'note_state.dart';

class CustomPage extends StatefulWidget {
  late final PageCubit pageCubit;
  final TextEditingController searchController = TextEditingController();
  CustomPage({Key? key}) : super(key: key);

  static const routeName = '/customPage';

  @override
  _CustomPageState createState() => _CustomPageState();
}

class _CustomPageState extends State<CustomPage> {
  late NoteCubit noteCubit;
  bool idkHowToDoAnotherWay = false;

  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  late PageModel selected;
  @override
  Widget build(BuildContext context) {
    if (idkHowToDoAnotherWay != true) {
      widget.pageCubit =
          ModalRoute.of(context)!.settings.arguments as PageCubit;
      noteCubit = NoteCubit();
      noteCubit.init(widget.pageCubit.getPage());
      widget.pageCubit.initRadioButtonInPagesWindow(
          widget.pageCubit.getListOfPages().first);
      idkHowToDoAnotherWay = true;
    }
    return BlocBuilder<NoteCubit, NoteState>(
      bloc: noteCubit,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
              title: Center(
                child: Text(state.page!.title),
              ),
              actions: noteCubit.areAppBarActionsDisplayed()
                  ? <Widget>[
                      IconButton(
                        icon: const Icon(Icons.select_all),
                        onPressed: () =>
                            noteCubit.setAllNotesSelectedUnselected(true),
                      ),
                      IconButton(
                        icon: const Icon(Icons.star),
                        onPressed: () => noteCubit.addNoteToFavorite(),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => noteCubit.deleteFromNoteList(),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: noteCubit.isEditIconEnable()
                            ? () {
                                _controller.text = noteCubit.editNote();
                              }
                            : null,
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy),
                        onPressed: () => noteCubit.copyDataToBuffer(),
                      ),
                    ]
                  : <Widget>[
                      noteCubit.getSerchBarDisplayedState()
                          ? Row(
                              children: [
                                Container(
                                  width: 150.0,
                                  height: 40.0,
                                  child: TextField(
                                    controller: widget.searchController,
                                    onChanged: (searchString) =>
                                        noteCubit.search(searchString),
                                    maxLines: 1,
                                    decoration: const InputDecoration(
                                      hintText: 'search..',
                                      fillColor: Colors.black12,
                                      filled: true,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => noteCubit.showSerchBar(
                                      false, widget.searchController),
                                  icon: const Icon(
                                    Icons.close,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            )
                          : IconButton(
                              onPressed: () {
                                noteCubit.showSerchBar(
                                    true, widget.searchController);
                              },
                              icon: const Icon(Icons.search),
                            )
                    ]),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: state.page!.notesList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 1.0, horizontal: 4.0),
                      child: Card(
                        color: state.page!.notesList[index].isSearched
                            ? Colors.green
                            : Colors.white,
                        child: ListTile(
                          key: ValueKey(state.page!.notesList[index].heading),
                          leading: Column(
                            children: [
                              Icon(
                                state.page!.icon,
                                color: Colors.black,
                              ),
                              Icon(
                                state.page!.notesList[index].icon,
                              ),
                            ],
                          ),
                          title: Text(
                            'Node ${state.page!.notesList[index].heading}',
                            style: TextStyle(
                                color: state.page!.notesList[index].isFavorite
                                    ? Colors.green
                                    : Colors.black),
                          ),
                          subtitle: Text(state.page!.notesList[index].data),
                          isThreeLine:
                              state.page!.notesList[index].data.length > 30
                                  ? true
                                  : false,
                          trailing: Checkbox(
                            key: UniqueKey(),
                            checkColor: Colors.white,
                            value: state.notesList![index].isChecked,
                            onChanged: (value) {
                              noteCubit.setSelectesCheckBoxState(value!, index);
                              value
                                  ? noteCubit.addNoteToSelectedNotesList(index)
                                  : noteCubit
                                      .removeNoteFromSelectedNotesList(index);
                            },
                          ),
                          onLongPress: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Choose a new page'),
                                content: Container(
                                  height: 200.0,
                                  width: 200.0,
                                  child: ListView.builder(
                                    itemCount: widget.pageCubit
                                        .getListOfPages()
                                        .length,
                                    itemBuilder: (context, index) {
                                      return Row(
                                        children: [
                                          Radio<PageModel>(
                                            value: widget.pageCubit
                                                .getListOfPages()[index],
                                            groupValue: widget.pageCubit
                                                .getPageSelectedToMove(),
                                            onChanged: (value) {
                                              widget.pageCubit
                                                  .setNewPageSelectedToMove(
                                                      value!);
                                            },
                                          ),
                                          Text(widget.pageCubit
                                              .getListOfPages()[index]
                                              .title),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(
                                          context,
                                          widget.pageCubit
                                              .getPageSelectedToMove());
                                    },
                                    child: const Text('Move to'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Close'),
                                  ),
                                ],
                                elevation: 1.0,
                              ),
                            ).then((value) {
                              if (value != null) {
                                widget.pageCubit
                                    .setNewPageSelectedToMove(value);
                                widget.pageCubit.moveNoteTo(state.page!, value,
                                    state.notesList![index]);
                                noteCubit.init(state.page!);
                              }
                            });
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
              NoteInput(
                noteCubit: noteCubit,
                controller: _controller,
              ),
            ],
          ),
        );
      },
    );
  }
}
