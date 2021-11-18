import 'package:flutter/material.dart';

import 'models/category.dart';

class CategoryCreatorView extends StatefulWidget {
  const CategoryCreatorView({Key? key, this.category}) : super(key: key);

  final Category? category;

  @override
  State<CategoryCreatorView> createState() => _CategoryCreatorViewState();
}

class _CategoryCreatorViewState extends State<CategoryCreatorView> {
  final TextEditingController _controller = TextEditingController();

  final _icons = <IconData>[
    Icons.account_balance,
    Icons.account_balance_wallet,
    Icons.airport_shuttle,
    Icons.album,
    Icons.alarm,
    Icons.assistant_photo,
    Icons.attach_money,
    Icons.audiotrack,
    Icons.beach_access,
    Icons.book,
    Icons.brush,
    Icons.business_center,
    Icons.cake,
    Icons.build,
    Icons.child_friendly,
    Icons.directions_boat,
    Icons.directions_bike,
    Icons.directions_run,
    Icons.domain,
    Icons.flight_takeoff,
    Icons.local_dining,
    Icons.weekend,
  ];

  IconData? _selectedIcon;

  void _onNewCategoryButtonPress() {
    if (_controller.text.isNotEmpty && _selectedIcon != null) {
      print(_selectedIcon.toString());
      Navigator.pop(
          context,
          Category(
              _controller.text,
              _selectedIcon!,
              widget.category?.favourite ?? false,
              widget.category?.created ?? DateTime.now()));
    }
  }

  void _onGridItemPress(IconData icon) {
    setState(() => _selectedIcon = icon);
    print(_selectedIcon.toString());
  }

  @override
  Widget build(BuildContext context) {
    if(widget.category!=null) _selectedIcon = widget.category!.icon;
    _controller.text = widget.category?.name ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.category == null ? 'Create New Category' : 'Editing Category',
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(30),
        alignment: Alignment.center,
        child: Column(
          children: [
            const Text(
              'Create New Category',
              style: TextStyle(fontSize: 20),
            ),
            TextField(
              controller: _controller,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 10,
            ),
            TextButton(
              child: const Text(
                'Create',
                style: TextStyle(fontSize: 30),
              ),
              onPressed: _onNewCategoryButtonPress,
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount:
                    (MediaQuery.of(context).size.width / 100).round(),
                children: _icons
                    .map(
                      (e) => GestureDetector(
                        child: Card(
                          shape: const CircleBorder(),
                          color:
                              _selectedIcon == e ? Colors.grey : Colors.white,
                          child: Icon(e),
                        ),
                        onTap: () => _onGridItemPress(e),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
