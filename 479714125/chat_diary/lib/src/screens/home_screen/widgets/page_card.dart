import 'package:flutter/material.dart';

import '../../events_screen/event_screen.dart';
import 'bottom_sheet_card.dart';

class PageCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final Future<void> Function(Key) deletePage;
  final Future<void> Function(Key, String) editPage;

  const PageCard({
    required Key? key,
    required this.icon,
    required this.title,
    required this.deletePage,
    required this.editPage,
  }) : super(key: key);

  @override
  State<PageCard> createState() => _PageCardState();
}

class _PageCardState extends State<PageCard> {
  final String _description = 'No Events. Click to create one.';
  bool _isHover = false;
  late Key _key;

  @override
  void initState() {
    super.initState();
    _key = widget.key!;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
      child: Ink(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          border: !_isHover ? Border.all() : Border.all(width: 3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EventScreen(title: widget.title),
              ),
            );
          },
          onHover: (value) => setState(
            () => _isHover = value,
          ),
          onLongPress: _showModalBottomSheet,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  child: Icon(
                    widget.icon,
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                  backgroundColor: Theme.of(context).colorScheme.secondary,
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

  void _showModalBottomSheet() {
    showModalBottomSheet<void>(
      context: context,
      builder: (_) {
        return SizedBox(
          height: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              BottomSheetCard(
                title: 'Edit Page',
                icon: Icons.edit,
                color: Colors.blue,
                action: () async {
                  await widget.editPage(_key, widget.title);
                  Navigator.pop(context);
                },
              ),
              BottomSheetCard(
                title: 'Delete Page',
                icon: Icons.delete,
                color: Colors.red,
                action: () async {
                  await widget.deletePage(_key);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
