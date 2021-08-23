import 'package:flutter/material.dart';

import '../../main.dart';

class GridViewBuild extends StatefulWidget {
  final int selectedIndex;
  final Function onIconChanged;

  GridViewBuild(
      {Key? key, required this.selectedIndex, required this.onIconChanged})
      : super(key: key);

  @override
  _GridViewBuildState createState() => _GridViewBuildState();
}

class _GridViewBuildState extends State<GridViewBuild> {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 4,
      scrollDirection: Axis.vertical,
      children: List.generate(
        listOfIcons.length,
        (index) => GestureDetector(
          onTap: () {
            widget.onIconChanged(index);
          },
          child: Container(
            margin: const EdgeInsets.all(15),
            padding: const EdgeInsets.all(5),
            child: Stack(
              children: [
                Center(
                  child: CircleAvatar(
                    child: Icon(
                      listOfIcons[index],
                    ),
                  ),
                ),
                widget.selectedIndex == index
                    ? Align(
                        alignment: Alignment.bottomRight,
                        child: Stack(
                          children: [
                            const CircleAvatar(
                              backgroundColor: Colors.green,
                              radius: 10,
                            ),
                            const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 20,
                            ),
                          ],
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
