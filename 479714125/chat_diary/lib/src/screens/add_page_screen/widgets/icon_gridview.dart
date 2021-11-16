import 'package:flutter/material.dart';

import '../../../resources/icon_list.dart';

class IconsGridView extends StatefulWidget {
  final void Function(IconData) changeSelectedIcon;
  const IconsGridView({
    Key? key,
    required this.changeSelectedIcon,
  }) : super(key: key);

  @override
  State<IconsGridView> createState() => _IconsGridViewState();
}

class _IconsGridViewState extends State<IconsGridView> {
  final List<IconData> _iconsOfPages = IconList.iconList;
  int _selectedIcon = 0;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: _iconsOfPages.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 20,
        crossAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        return IconButton(
          onPressed: () {
            widget.changeSelectedIcon(_iconsOfPages[index]);
            setState(() => _selectedIcon = index);
          },
          icon: Icon(
            _iconsOfPages[index],
            color: _selectedIcon == index
                ? Theme.of(context).primaryColor
                : Theme.of(context).colorScheme.onSecondary,
          ),
        );
      },
    );
  }
}
