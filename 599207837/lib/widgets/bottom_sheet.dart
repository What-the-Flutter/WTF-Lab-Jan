import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../entity/entities.dart' as entity;
import '../main.dart';
import 'items_page/items_page_cubit.dart';
import 'topic_maker/topic_maker.dart';

class AddingButton extends StatefulWidget {
  final Icon firstIcon, secondIcon;

  const AddingButton({
    Key? key,
    required this.firstIcon,
    required this.secondIcon,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AddingButtonState();
}

class _AddingButtonState extends State<AddingButton> {
  late Icon _firstIcon, _secondIcon, _mainIcon;
  PersistentBottomSheetController? bottomSheetController;

  @override
  void initState() {
    super.initState();
    _firstIcon = widget.firstIcon;
    _secondIcon = widget.secondIcon;
    _mainIcon = _firstIcon;
  }

  PersistentBottomSheetController _showBottomSheet(BuildContext ctxOfScaffold) {
    return Scaffold.of(ctxOfScaffold).showBottomSheet<void>((context) {
      return Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
          color: Colors.grey,
        ),
        height: 250,
        child: _BottomForm(
          sheetState: this,
          currentPage: DefaultTabController.of(context)!.index,
        ),
      );
    });
  }

  void _hideBottomSheet(PersistentBottomSheetController controller) {
    controller.close();
  }

  @override
  Widget build(BuildContext context) {
    final themeInherited = ThemeInherited.of(context)!;
    return Builder(
      builder: (ctxOfScaffold) {
        return FloatingActionButton(
          backgroundColor: themeInherited.preset.colors.buttonColor,
          onPressed: () {
            if (DefaultTabController.of(context)!.index == 0) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (newContext) => TopicMaker(
                    themeInherited: themeInherited,
                    onChange: () => context.read<ItemsPageCubit>().onTopicsChange(),
                  ),
                ),
              );
            } else {
              if (bottomSheetController == null) {
                bottomSheetController = _showBottomSheet(ctxOfScaffold);
                setState(() => _mainIcon = _secondIcon);
              } else {
                _hideBottomSheet(bottomSheetController!);
                bottomSheetController = null;
                setState(() => _mainIcon = _firstIcon);
              }
            }
          },
          tooltip: 'Add new',
          child: _mainIcon,
        );
      },
    );
  }
}

class _BottomForm extends StatefulWidget {
  final _AddingButtonState sheetState;
  final int currentPage;

  const _BottomForm({
    Key? key,
    required this.sheetState,
    required this.currentPage,
  }) : super(key: key);

  @override
  State<_BottomForm> createState() => _BottomFormState();
}

class _BottomFormState extends State<_BottomForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _comboBoxValue;
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _categoryController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.currentPage) {
      case 1:
        return Container();
      case 2:
        return Container();
      case 3:
        return _taskBottomForm();
      default:
        return Container();
    }
  }

  Widget _taskBottomForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.white54,
                ),
                margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 5.0),
                alignment: Alignment.centerLeft,
                width: 130,
                child: TextFormField(
                  controller: _categoryController,
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 25.0,
                ),
                child: DropdownButton<String>(
                  value: _comboBoxValue,
                  icon: const Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  style: const TextStyle(color: Colors.black54),
                  underline: Container(
                    height: 2,
                    color: Colors.blueAccent,
                  ),
                  onChanged: (newValue) {
                    setState(() {
                      _comboBoxValue = newValue!;
                      _categoryController.text = newValue;
                    });
                  },
                  items: entity.topics.values.map<DropdownMenuItem<String>>((value) {
                    return DropdownMenuItem<String>(
                      value: value.toString(),
                      child: Text(value.toString()),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Colors.white54,
            ),
            margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
            child: TextFormField(
              controller: _descriptionController,
              maxLines: 3,
              inputFormatters: [LengthLimitingTextInputFormatter(200)],
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                entity.MessageLoader.messages[0].insert(
                  0,
                  entity.Task(
                    description: _descriptionController.text,
                    topic: entity.Topic(
                        name: _categoryController.text, icon: Icons.delete_outline_rounded),
                    favourite: true,
                  ),
                );
                final parent = widget.sheetState;
                parent._hideBottomSheet(parent.bottomSheetController!);
                parent.bottomSheetController = null;
                parent.setState(() => parent._mainIcon = parent._firstIcon);
              },
              child: const Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}
