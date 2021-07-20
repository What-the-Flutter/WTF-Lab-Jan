import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../util/domain.dart';
import 'add_page_cubit.dart';

class AddCategoryPage extends StatefulWidget {
  final List<Category> categoriesList;
  final List<IconData> icons = initialIcons;
  final bool isEditing;
  final int indexOfCategory;

  AddCategoryPage(
      {Key? key,
      required this.categoriesList,
      required this.isEditing,
      required this.indexOfCategory})
      : super(key: key);

  AddCategoryPage.add(
      {this.categoriesList = const <Category>[],
      this.isEditing = false,
      this.indexOfCategory = 0});

  @override
  _AddCategoryPageState createState() => _AddCategoryPageState();
}

class _AddCategoryPageState extends State<AddCategoryPage> {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    BlocProvider.of<AddPageCubit>(context).init(widget.isEditing
        ? widget.categoriesList[widget.indexOfCategory].iconIndex
        : 0);
    if (widget.isEditing) {
      _textEditingController.text =
          widget.categoriesList[widget.indexOfCategory].name;
    }
    _focusNode.requestFocus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddPageCubit, AddPageState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: widget.isEditing
                ? Center(
                    child: Text('Update Page'),
                  )
                : Center(
                    child: Text('Create a new Page'),
                  ),
          ),
          floatingActionButton: FloatingActionButton(
            child:
                widget.isEditing ? Icon(Icons.auto_awesome) : Icon(Icons.add),
            onPressed: () {
              _textEditingController.text.isEmpty
                  ? () {}
                  : widget.isEditing
                      ? _update(state, context)
                      : _create(state, context);
            },
          ),
          body: _iconsListView(state),
        );
      },
    );
  }

  void _update(AddPageState state, BuildContext context) {
    widget.categoriesList[widget.indexOfCategory].iconIndex =
        state.selectedIconIndex;
    widget.categoriesList[widget.indexOfCategory].name =
        _textEditingController.text;
    BlocProvider.of<AddPageCubit>(context).editPage(
      widget.categoriesList[widget.indexOfCategory],
    );
    Navigator.of(context).pop();
    _textEditingController.clear();
  }

  void _create(AddPageState state, BuildContext context) async {
    var category = Category(
      id: -1,
      name: _textEditingController.text,
      iconIndex: state.selectedIconIndex,
      dateTime: DateFormat('yyyy-MM-dd kk:mm').format(
        DateTime.now(),
      ),
    );
    await BlocProvider.of<AddPageCubit>(context).addPage(category);
    Navigator.of(context).pop();
    _textEditingController.clear();
  }

  ListView _iconsListView(AddPageState state) {
    return ListView.separated(
      itemCount: widget.icons.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Center(
            child: Container(
              width: 350.0,
              height: 80.0,
              padding: const EdgeInsets.all(4.0),
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextField(
                      controller: _textEditingController,
                      focusNode: _focusNode,
                      decoration: InputDecoration(
                        hintText: 'Enter name of the Page',
                        border: InputBorder.none,
                        filled: false,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
          );
        }
        return ListTile(
          title: Text('tab to select this icon'),
          subtitle: Text('#${index - 1}'),
          leading: CircleAvatar(
            foregroundColor: Colors.black54,
            child: Icon(
              widget.icons[index - 1],
            ),
          ),
          onTap: () {
            BlocProvider.of<AddPageCubit>(context)
                .setSelectedIconIndex(index - 1);
          },
          selected: state.selectedIconIndex == index - 1,
        );
      },
      separatorBuilder: (context, index) => const Divider(),
    );
  }
}
