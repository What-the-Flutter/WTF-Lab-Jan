import 'package:flutter/material.dart';

import '../../components/floating_action_button.dart';
import '../../models/page_model.dart';
import '../../resources/icon_list.dart';
import 'widgets/icon_gridview.dart';

class AddPageScreen extends StatefulWidget {
  final String title;
  final String? titleOfPage;

  const AddPageScreen({
    Key? key,
    required this.title,
    this.titleOfPage,
  }) : super(key: key);

  @override
  State<AddPageScreen> createState() => _AddPageScreenState();
}

class _AddPageScreenState extends State<AddPageScreen> {
  late final FocusNode _focusNode;
  late final TextEditingController _inputController;
  IconData _selectedIcon = IconList.iconList[0];

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() => setState(() {}));
    _inputController = TextEditingController();
    var titleOfPage = widget.titleOfPage;
    if (titleOfPage != null) {
      _inputController.text = titleOfPage;
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 35),
            child: Column(
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _inputController,
                  focusNode: _focusNode,
                  decoration: InputDecoration(
                    labelText: 'Name of the Page',
                    labelStyle: TextStyle(
                        color: _focusNode.hasFocus
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).colorScheme.onSecondary),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 10,
                    ),
                    border: const OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 2,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: IconsGridView(
                    changeSelectedIcon: _changeSelectedIcon,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: AppFloatingActionButton(
        onPressed: () {
          if (_inputController.text.isNotEmpty) {
            final result =
                PageModel(name: _inputController.text, icon: _selectedIcon);

            Navigator.pop(context, result);
          }
        },
        child: const Icon(Icons.close, size: 50),
      ),
    );
  }

  void _changeSelectedIcon(IconData icon) =>
      setState(() => _selectedIcon = icon);
}
