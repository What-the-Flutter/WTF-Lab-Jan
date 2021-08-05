import 'package:flutter/material.dart';

class CreatePage extends StatelessWidget {
  CreatePage(
      {Key? key,
      this.isEdit = false,
      this.pageTitle = '',
      this.pageIcon = Icons.book})
      : super(key: key);
  final bool isEdit;
  final String pageTitle;
  final IconData pageIcon;
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    controller.text = pageTitle;
    _IconsListState.selectedIconIndex = iconsList.indexOf(pageIcon);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.text.isNotEmpty
            ? Navigator.pop(context,
                <Object>[controller.text, _IconsListState.selectedIconIndex])
            : Navigator.pop(context),
        tooltip: 'Save',
        child: Icon(Icons.done_outlined),
        backgroundColor: Theme.of(context).accentColor,
      ),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 30),
                child: Text(
                  isEdit ? 'Edit Page' : 'Create a new Page',
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.only(left: 30, top: 18, right: 30, bottom: 20),
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    filled: true,
                    labelText: 'Name of the Page',
                  ),
                ),
              ),
              IconsList(),
            ],
          ),
        ),
      ),
    );
  }
}

class IconsList extends StatefulWidget {
  const IconsList({Key? key}) : super(key: key);

  @override
  _IconsListState createState() => _IconsListState();
}

class _IconsListState extends State<IconsList> {
  static int selectedIconIndex = 0;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: iconsList.length,
      itemBuilder: (context, index) {
        return IconButton(
          icon: CircleAvatar(
            backgroundColor: selectedIconIndex == index
                ? Theme.of(context).accentColor
                : Colors.blueGrey[600],
            radius: 28,
            child: Icon(iconsList[index], size: 35, color: Colors.white),
          ),
          onPressed: () {
            selectedIconIndex = index;
            setState(() {});
          },
        );
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 5.0,
        crossAxisSpacing: 7.0,
      ),
    );
  }
}

final iconsList = <IconData>[
  Icons.book,
  Icons.import_contacts_outlined,
  Icons.nature_people_outlined,
  Icons.info,
  Icons.mail,
  Icons.ac_unit,
  Icons.access_time,
  Icons.camera_alt,
  Icons.hail,
  Icons.all_inbox,
];
