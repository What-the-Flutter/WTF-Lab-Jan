import 'package:flutter/material.dart';

import '../../components/floating_action_button.dart';
import '../../models/page_model.dart';
import '../../resources/icon_list.dart';
import '../../theme/app_colors.dart';
import 'widgets/icon_gridview.dart';

class AddPageScreen extends StatefulWidget {
  const AddPageScreen({Key? key}) : super(key: key);

  @override
  State<AddPageScreen> createState() => _AddPageScreenState();
}

class _AddPageScreenState extends State<AddPageScreen> {
  late final FocusNode _focusNode;
  late final TextEditingController _inputController;
  var _selectedIcon = IconList.iconList[0];

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(
      () => setState(() {}),
    );
    _inputController = TextEditingController();
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
                const Text(
                  'Create a new Page',
                  style: TextStyle(
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
                          ? AppColors.bluePurple
                          : AppColors.black,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 10,
                    ),
                    border: const OutlineInputBorder(),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.bluePurple,
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

  // ignore: use_setters_to_change_properties
  void _changeSelectedIcon(IconData icon) {
    _selectedIcon = icon;
  }
}
