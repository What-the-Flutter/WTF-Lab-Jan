import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../entity/entities.dart' as custom;
import '../main.dart';

class AddingButton extends StatefulWidget {
  final Icon firstIcon, secondIcon;

  const AddingButton(
      {Key? key, required this.firstIcon, required this.secondIcon})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _AddingButtonState();
}

class _AddingButtonState extends State<AddingButton> {
  late Icon firstIcon, secondIcon, mainIcon;
  PersistentBottomSheetController? bottomSheetController;

  @override
  void initState() {
    super.initState();
    firstIcon = widget.firstIcon;
    secondIcon = widget.secondIcon;
    mainIcon = firstIcon;
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
        ),
      );
    });
  }

  void _hideBottomSheet(PersistentBottomSheetController controller) {
    controller.close();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (ctxOfScaffold) {
        return FloatingActionButton(
          onPressed: () {
            if (bottomSheetController == null) {
              bottomSheetController = _showBottomSheet(ctxOfScaffold);
              setState(() {
                mainIcon = secondIcon;
              });
            } else {
              _hideBottomSheet(bottomSheetController!);
              bottomSheetController = null;
              setState(() {
                mainIcon = firstIcon;
              });
            }
          },
          tooltip: 'Add new',
          child: mainIcon,
        );
      },
    );
  }
}

class _BottomForm extends StatefulWidget {
  final _AddingButtonState sheetState;

  const _BottomForm({Key? key, required this.sheetState}) : super(key: key);

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
                margin: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 25.0),
                padding:
                    const EdgeInsets.symmetric(vertical: 1.0, horizontal: 5.0),
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
                  items: custom.topics.values
                      .map<DropdownMenuItem<String>>((value) {
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
            margin:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
            padding:
                const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
            child: TextFormField(
              controller: _descriptionController,
              maxLines: 3,
              inputFormatters: [LengthLimitingTextInputFormatter(200)],
            ),
          ),
          Center(
            //padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
                final inherited = TabContrDecorator.of(context)!;
                inherited.pendingTasks.add(custom.Task(
                  description: _descriptionController.text,
                  topic: custom.Topic(
                    name: _categoryController.text,
                  ),
                ));
                inherited.onEdited();
                var parent = widget.sheetState;
                parent._hideBottomSheet(parent.bottomSheetController!);
                parent.bottomSheetController = null;
                parent.setState(() => parent.mainIcon = parent.firstIcon);
              },
              child: const Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}
