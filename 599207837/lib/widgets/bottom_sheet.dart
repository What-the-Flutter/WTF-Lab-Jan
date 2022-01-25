import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../database/database.dart';
import '../entity/entities.dart';
import '../main.dart';
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

  @override
  void initState() {
    super.initState();
    _firstIcon = widget.firstIcon;
    _secondIcon = widget.secondIcon;
    _mainIcon = _firstIcon;
  }

  @override
  Widget build(BuildContext context) {
    final themeInherited = ThemeInherited.of(context)!;
    return Builder(
      builder: (ctxOfScaffold) {
        return FloatingActionButton(
          key: widget.key,
          backgroundColor: themeInherited.preset.colors.buttonColor,
          onPressed: () async {
            if (DefaultTabController.of(context)!.index == 0) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (newContext) => const TopicMaker(),
                ),
              );
            } else {
              _showBottomSheet();
              setState(() => _mainIcon = _secondIcon);
            }
          },
          tooltip: 'Add new',
          child: _mainIcon,
        );
      },
    );
  }

  Future _showBottomSheet() {
    final themeInherited = ThemeInherited.of(context)!;
    return showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (newContext) => Container(
        padding: MediaQuery.of(context).viewInsets,
        child: Stack(
          clipBehavior: Clip.none,
          fit: StackFit.expand,
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                  color: themeInherited.preset.colors.backgroundColor,
                ),
                child: _BottomForm(
                  sheetState: this,
                  currentPage: DefaultTabController.of(context)!.index,
                  whenComplete: () {
                    Navigator.pop(context);
                    setState(() => _mainIcon = _firstIcon);
                  },
                ),
              ),
            ),
            Positioned(
              bottom: 240,
              right: 16,
              child: FloatingActionButton(
                key: widget.key,
                backgroundColor: themeInherited.preset.colors.buttonColor,
                onPressed: () => Navigator.pop(context),
                tooltip: 'Add new',
                child: _mainIcon,
              ),
            ),
          ],
        ),
      ),
      context: context,
      isDismissible: true,
    ).whenComplete(() {
      setState(() => _mainIcon = _firstIcon);
    });
  }
}

class _BottomForm extends StatefulWidget {
  final _AddingButtonState sheetState;
  final int currentPage;
  final Function whenComplete;

  const _BottomForm({
    Key? key,
    required this.sheetState,
    required this.currentPage,
    required this.whenComplete,
  }) : super(key: key);

  @override
  State<_BottomForm> createState() => _BottomFormState();
}

class _BottomFormState extends State<_BottomForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _comboBoxValue;
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.currentPage) {
      case 1:
        return _taskBottomForm();
      case 2:
        return Container();
      default:
        return Container();
    }
  }

  Widget _taskBottomForm() {
    final themeInherited = ThemeInherited.of(context)!;
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 25.0,
              ),
              child: DropdownButton<String>(
                value: _comboBoxValue,
                icon: const Icon(Icons.keyboard_arrow_down),
                iconSize: 24,
                elevation: 16,
                style: TextStyle(color: themeInherited.preset.colors.textColor1),
                underline: Container(
                  height: 2,
                  color: themeInherited.preset.colors.underlineColor,
                ),
                onChanged: (newValue) {
                  setState(() => _comboBoxValue = newValue!);
                },
                items: topics.values.map<DropdownMenuItem<String>>((value) {
                  return DropdownMenuItem<String>(
                    value: value.toString(),
                    child: Text(value.toString()),
                  );
                }).toList(),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                color: themeInherited.preset.colors.themeColor2,
                border: Border.all(color: themeInherited.preset.colors.underlineColor),
              ),
              margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
              padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
              child: TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                inputFormatters: [LengthLimitingTextInputFormatter(200)],
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  contentPadding: EdgeInsets.all(3),
                ),
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (_descriptionController.text.isNotEmpty && _comboBoxValue != null) {
                    MessageRepository.add(
                      Task(
                        description: _descriptionController.text,
                        topic: topics[_comboBoxValue!]!,
                        favourite: true,
                      ),
                    );
                    widget.whenComplete();
                  }
                },
                child: const Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
