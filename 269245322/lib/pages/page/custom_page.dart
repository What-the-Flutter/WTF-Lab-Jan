import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../main.dart';
import '../../models/page_model.dart';
import '../page_constructor/page_cubit.dart';
import 'note_cubit.dart';
import 'note_input.dart';
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
  final NoteCubit _noteCubit = NoteCubit();
  bool _idkHowToDoAnotherWay = false;

  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  late PageModel selected;
  @override
  Widget build(BuildContext context) {
    if (_idkHowToDoAnotherWay != true) {
      widget.pageCubit =
          ModalRoute.of(context)!.settings.arguments as PageCubit;
      _noteCubit.initPage(widget.pageCubit.getPage());
      widget.pageCubit.init();
      _idkHowToDoAnotherWay = true;
    }
    return BlocBuilder<NoteCubit, NoteState>(
      bloc: _noteCubit,
      builder: (context, state) {
        return Scaffold(
          appBar: _appBar(
            noteCubit: _noteCubit,
            state: state,
            controller: _controller,
            searchController: widget.searchController,
            context: context,
          ),
          body: _body(
            context: context,
            state: state,
            noteCubit: _noteCubit,
            pageCubit: widget.pageCubit,
            controller: _controller,
          ),
          backgroundColor: Theme.of(context).backgroundColor,
        );
      },
    );
  }
}

AppBar _appBar({
  required NoteCubit noteCubit,
  required NoteState state,
  required TextEditingController controller,
  required TextEditingController searchController,
  required BuildContext context,
}) {
  return AppBar(
    title: Center(
      child: Text(state.page!.title),
    ),
    actions: noteCubit.areAppBarActionsDisplayed()
        ? _appBarActionBittons(noteCubit, context, controller)
        : _appBarSearchBar(noteCubit, searchController),
  );
}

List<Widget> _appBarActionBittons(NoteCubit noteCubit, BuildContext context,
    TextEditingController controller) {
  return <Widget>[
    IconButton(
      icon: const Icon(Icons.select_all),
      onPressed: () => noteCubit.setAllNotesSelectedUnselected(true),
      color: Theme.of(context).colorScheme.onBackground,
    ),
    IconButton(
      icon: const Icon(Icons.star),
      onPressed: () => noteCubit.addNoteToFavorite(),
      color: Theme.of(context).colorScheme.onBackground,
    ),
    IconButton(
      icon: const Icon(Icons.delete),
      onPressed: () => noteCubit.deleteFromNoteList(),
      color: Theme.of(context).colorScheme.onBackground,
    ),
    IconButton(
      icon: const Icon(Icons.edit),
      onPressed: noteCubit.isEditIconEnable()
          ? () => controller.text = noteCubit.editNote()
          : null,
      color: Theme.of(context).colorScheme.onBackground,
    ),
    IconButton(
      icon: const Icon(Icons.copy),
      onPressed: () => noteCubit.copyDataToBuffer(),
      color: Theme.of(context).colorScheme.onBackground,
    ),
  ];
}

List<Widget> _appBarSearchBar(
    NoteCubit noteCubit, TextEditingController searchController) {
  return <Widget>[
    noteCubit.getSerchBarDisplayedState()
        ? _searchBar(noteCubit, searchController)
        : _searchBarButton(noteCubit, searchController)
  ];
}

Widget _searchBar(NoteCubit noteCubit, TextEditingController searchController) {
  return Row(
    children: [
      Container(
        width: 150.0,
        height: 40.0,
        child: TextField(
          controller: searchController,
          onChanged: (searchString) => noteCubit.search(searchString),
          maxLines: 1,
          decoration: const InputDecoration(
            hintText: 'search..',
            fillColor: Colors.black12,
            filled: true,
          ),
        ),
      ),
      IconButton(
        onPressed: () => noteCubit.showSerchBar(false, searchController),
        icon: const Icon(
          Icons.close,
          color: Colors.red,
        ),
      ),
    ],
  );
}

IconButton _searchBarButton(
    NoteCubit noteCubit, TextEditingController searchController) {
  return IconButton(
    onPressed: () {
      noteCubit.showSerchBar(true, searchController);
    },
    icon: const Icon(Icons.search),
  );
}

Widget _body({
  required BuildContext context,
  required NoteState state,
  required NoteCubit noteCubit,
  required PageCubit pageCubit,
  required TextEditingController controller,
}) {
  return SingleChildScrollView(
    child: ConstrainedBox(
      constraints:
          BoxConstraints(maxHeight: MediaQuery.of(context).size.height - 80.0),
      child: Column(
        children: [
          Expanded(
            flex: 14,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: state.page!.notesList.length,
              itemBuilder: (context, index) {
                return _listTile(
                  context: context,
                  pageCubit: pageCubit,
                  noteCubit: noteCubit,
                  state: state,
                  index: index,
                );
              },
            ),
          ),
          Expanded(
            flex: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                NoteInput(
                  noteCubit: noteCubit,
                  controller: controller,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _listTile({
  required BuildContext context,
  required PageCubit pageCubit,
  required NoteCubit noteCubit,
  required NoteState state,
  required int index,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 4.0),
    child: Slidable(
      key: const ValueKey(0),
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        dismissible: DismissiblePane(onDismissed: () {}),
        children: const [
          SlidableAction(
            onPressed: null,
            backgroundColor: Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: 'Edit',
          ),
        ],
      ),
      endActionPane: const ActionPane(
        motion: ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: null,
            backgroundColor: Color(0xFF0392CF),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'delete',
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: noteCubit.isCenterAlignent()
            ? MainAxisAlignment.center
            : MainAxisAlignment.start,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width - 10.0,
            ),
            child: Card(
              color: state.page!.notesList[index].isSearched
                  ? Colors.green
                  : Theme.of(context).cardColor,
              child: IntrinsicWidth(
                child: ListTile(
                  key: ValueKey(state.page!.notesList[index].heading),
                  leading: Column(
                    children: [
                      Icon(
                        pageIcons[state.page!.icon],
                        color: Theme.of(context).primaryIconTheme.color,
                      ),
                      Icon(
                        noteMenuItemList[state.page!.notesList[index].icon]!
                            .iconData,
                        color: Theme.of(context).iconTheme.color,
                      ),
                    ],
                  ),
                  title: Text(
                    'Note ${state.page!.notesList[index].heading}',
                    maxLines: 1,
                    style: TextStyle(
                      color: state.page!.notesList[index].isFavorite
                          ? Colors.green
                          : Theme.of(context).colorScheme.primaryVariant,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.page!.notesList[index].data,
                        style: TextStyle(
                          fontSize: noteCubit.getTextSize(),
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      Text(
                        state.page!.notesList[index].tags!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondaryVariant,
                        ),
                      ),
                    ],
                  ),
                  isThreeLine: state.page!.notesList[index].data.length > 30
                      ? true
                      : false,
                  trailing: Checkbox(
                    key: UniqueKey(),
                    checkColor: Theme.of(context).primaryColor,
                    activeColor: Theme.of(context).indicatorColor,
                    value: state.notesList![index].isChecked,
                    onChanged: (value) {
                      noteCubit.setSelectesCheckBoxState(value!, index);
                      value
                          ? noteCubit.addNoteToSelectedNotesList(index)
                          : noteCubit.removeNoteFromSelectedNotesList(index);
                    },
                  ),
                  onLongPress: () => _onElementLongPress(
                    context: context,
                    pageCubit: pageCubit,
                    state: state,
                    index: index,
                    noteCubit: noteCubit,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

void _onElementLongPress({
  required BuildContext context,
  required PageCubit pageCubit,
  required NoteState state,
  required int index,
  required NoteCubit noteCubit,
}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Choose a new page'),
      content: Container(
        height: 200.0,
        width: 200.0,
        child: ListView.builder(
          itemCount: pageCubit.getListOfPages().length,
          itemBuilder: (context, index) {
            return Row(
              children: [
                Radio<PageModel>(
                  value: pageCubit.getListOfPages()[index],
                  groupValue: pageCubit.getPageSelectedToMove(),
                  onChanged: (value) {
                    pageCubit.setNewPageSelectedToMove(value!);
                  },
                ),
                Text(pageCubit.getListOfPages()[index].title),
              ],
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, pageCubit.getPageSelectedToMove());
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
      pageCubit.setNewPageSelectedToMove(value);
      pageCubit.moveNoteTo(value, state.notesList![index]);
      noteCubit.initPage(state.page!);
    }
  });
}
