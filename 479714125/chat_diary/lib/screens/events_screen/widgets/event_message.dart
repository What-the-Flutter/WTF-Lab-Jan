import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

class EventMessage extends StatefulWidget {
  final String text;
  final String date;

  const EventMessage({
    Key? key,
    required this.text,
    required this.date,
  }) : super(key: key);

  @override
  State<EventMessage> createState() => _EventMessageState();
}

class _EventMessageState extends State<EventMessage> {
  bool _isSelected = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 5,
        bottom: 5,
        top: 5,
        right: 20,
      ),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: GestureDetector(
          onLongPress: () => setState(() {
            _isSelected = !_isSelected;
          }),

          onTap: () {},
          // onLongPress: () => setState(() {
          //   isSelected = !isSelected;
          //if (_isSelected) showPopupMenu(context);
          // }),
          // onTap: () {
          //   if (_isSelected) {
          //     setState(
          //       () => _isSelected = !_isSelected,
          //     );
          //   }
          // },
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: _isSelected ? AppColors.blue400 : AppColors.blue200,
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.text,
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    widget.date,
                    style: const TextStyle(color: AppColors.grey600),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // void showPopupMenu(BuildContext context) {
  //   showMenu<String>(
  //     context: context,
  //     position: const RelativeRect.fromLTRB(25.0, 25.0, 0.0, 0.0),
  //     items: [
  //       const PopupMenuItem<String>(child: Text('menu option 1'), value: '1'),
  //       const PopupMenuItem<String>(child: Text('menu option 2'), value: '2'),
  //       const PopupMenuItem<String>(child: Text('menu option 3'), value: '3'),
  //     ],
  //     elevation: 8.0,
  //   ).then<void>((itemSelected) {
  //     if (itemSelected == null) {
  //       _isSelected = !_isSelected;
  //       return;
  //     }

  //     if (itemSelected == '1') {
  //       //code here
  //     } else if (itemSelected == '2') {
  //       //code here
  //     } else {
  //       //code here
  //     }
  //     _isSelected = !_isSelected;
  //   });
  // }
}
