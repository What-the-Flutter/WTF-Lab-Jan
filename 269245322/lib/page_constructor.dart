import 'package:flutter/material.dart';
import 'objects/lists.dart';

import 'objects/page_object.dart';

final Map<int, IconData> _pageIcons = {
  0: Icons.pool,
  1: Icons.sports_esports,
  2: Icons.self_improvement,
  3: Icons.whatshot,
  4: Icons.person,
  5: Icons.people,
  6: Icons.mood,
  7: Icons.school,
  8: Icons.sports,
};

class PageConstructor extends StatefulWidget {
  final PageObject page = PageObject(title: '', icon: _pageIcons[0]!);
  PageConstructor({Key? key}) : super(key: key);

  static const routeName = '/pageConstructor';

  @override
  _PageConstructorState createState() => _PageConstructorState();
}

class _PageConstructorState extends State<PageConstructor> {
  bool idkHowToDoAnotherWay = false;
  bool createNewPageChecker = true;
  late IconData? _selectedIcon;
  final TextEditingController _controller = TextEditingController();

  void addNewPage() {
    widget.page.title = _controller.text;
    widget.page.icon = _selectedIcon!;
    widget.page.cretionDate = DateTime.now();
    widget.page.lastModifedDate = DateTime.now();
    setState(() {
      listOfPages.add(widget.page);
    });
    Navigator.pop(context);
  }

  void editExistingPage() {
    for (var page in listOfPages) {
      if (widget.page.title == page.title) {
        page.title = _controller.text;
        page.icon = _selectedIcon!;
        break;
      }
    }
    Navigator.pop(context);
  }

  // @override
  // void didChangeDependencies() {
  //   widget.page.title =
  //       (ModalRoute.of(context)!.settings.arguments as PageObject).title;
  //   widget.page.icon =
  //       (ModalRoute.of(context)!.settings.arguments as PageObject).icon;
  //   _selectedIcon = widget.page.icon;
  //   _controller.text = widget.page.title;
  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    if (idkHowToDoAnotherWay != true) {
      widget.page.title =
          (ModalRoute.of(context)!.settings.arguments as PageObject).title;
      widget.page.icon =
          (ModalRoute.of(context)!.settings.arguments as PageObject).icon;
      _selectedIcon = widget.page.icon;
      _controller.text = widget.page.title;
      if (widget.page.title != '') createNewPageChecker = false;
      idkHowToDoAnotherWay = true;
    }
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
        child: Column(
          children: [
            const Text(
              'Create a new page',
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(5.0),
              child: TextField(
                controller: _controller,
                maxLines: 1,
                maxLength: 50,
                decoration: const InputDecoration(
                  hintText: 'new node',
                  fillColor: Colors.black12,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
              ),
            ),
            const Divider(
              height: 50.0,
              thickness: 2.0,
              indent: 10.0,
              endIndent: 10.0,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 50.0,
                  vertical: 0.0,
                ),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 5.0,
                    crossAxisSpacing: 5.0,
                  ),
                  itemCount: _pageIcons.length,
                  itemBuilder: (ctx, index) {
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.blue,
                          key: UniqueKey(),
                          child: Icon(
                            _pageIcons[index],
                            color: Colors.black,
                            size: 35.0,
                          ),
                        ),
                        Positioned(
                          top: 35.0,
                          left: 30.0,
                          child: Radio<IconData>(
                            value: _pageIcons[index]!,
                            groupValue: _selectedIcon,
                            onChanged: (value) {
                              setState(() {
                                _selectedIcon = value;
                                print(_selectedIcon);
                              });
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: createNewPageChecker ? addNewPage : editExistingPage,
                child: Text(createNewPageChecker ? 'create' : 'edit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
