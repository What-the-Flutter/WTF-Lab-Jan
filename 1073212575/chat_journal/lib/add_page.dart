import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

import 'event_classes.dart';
import 'home_page.dart';
import 'themes.dart';

class AddPage extends StatefulWidget {
  final bool needsEditing;
  final selectedPageIndex;
  const AddPage({Key? key, required this.needsEditing, this.selectedPageIndex})
      : super(key: key);

  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final List _iconsList = [
    Icons.delete_rounded,
    Icons.wash_rounded,
    Icons.wine_bar_rounded,
    Icons.widgets_rounded
  ];

  var _selectedIconIndex;
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Theme.of(context).colorScheme.secondary,
            Theme.of(context).colorScheme.onSecondary,
            Theme.of(context).colorScheme.secondaryVariant,
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: _appBar(),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _textField(),
              Expanded(
                child: _icons(),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: widget.needsEditing ? _edit : _addPage,
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: Icon(
            Icons.add,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(radiusValue),
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text('Create a new page'),
    );
  }

  Widget _textField() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(
          Radius.circular(radiusValue),
        ),
        child: Container(
          height: 70,
          color: Theme.of(context).colorScheme.onPrimary,
          child: TextField(
            controller: _controller,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.all(10),
              border: InputBorder.none,
              hintText: 'Name of the Page',
              hintStyle: TextStyle(
                color: Color(0xFFE5E0EF),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _icons() {
    return GridView.builder(
      itemCount: _iconsList.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
      ),
      itemBuilder: (context, i) => _icon(_iconsList[i], i),
    );
  }

  Widget _icon(IconData iconData, int i) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: ClipOval(
        child: Container(
          color: i == _selectedIconIndex
              ? Theme.of(context).colorScheme.onPrimary
              : Colors.transparent,
          child: GestureDetector(
            onTap: () => setState(() => _selectedIconIndex = i),
            child: Icon(
              iconData,
              color: Theme.of(context).colorScheme.onBackground,
              size: 40,
            ),
          ),
        ),
      ),
    );
  }

  void _addPage() {
    setState(() {
      eventPages.add(
        EventPages(
          _controller.text,
          _iconsList[_selectedIconIndex],
          [],
          Jiffy(DateTime.now()).format('d/M/y h:mm a'),
        ),
      );
    });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(),
      ),
    );
  }

  void _edit() {
    setState(() {
      var tempMessages = eventPages[widget.selectedPageIndex].eventMessages;
      var tempDate = eventPages[widget.selectedPageIndex].date;
      var tempName = _controller.text;
      var tempIcon = _iconsList[_selectedIconIndex];
      var tempEventPages =
          EventPages(tempName, tempIcon, tempMessages, tempDate);
      eventPages.removeAt(widget.selectedPageIndex);
      eventPages.insert(widget.selectedPageIndex, tempEventPages);
    });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(),
      ),
    );
  }
}
