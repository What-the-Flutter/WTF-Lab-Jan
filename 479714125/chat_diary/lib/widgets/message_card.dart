import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class MessageCard extends StatefulWidget {
  final IconData icon;
  final String title;
  const MessageCard({
    Key? key,
    required this.icon,
    required this.title,
  }) : super(key: key);

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  final _description = 'No Events. Click to create one.';
  bool _isHover = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
      child: Ink(
        decoration: BoxDecoration(
          color: AppColors.lightBlue,
          border: !_isHover ? Border.all() : Border.all(width: 3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {},
          onHover: (value) => setState(
            () => _isHover = value,
          ),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  child: Icon(
                    widget.icon,
                    color: Colors.black,
                  ),
                  backgroundColor: AppColors.sandPurple,
                ),
                const SizedBox(width: 15),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _description,
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
