// import 'package:flutter/material.dart';
// import '../../objects/page_object.dart';

// class NoteList extends StatefulWidget {
//   late final PageObject page;
//   NoteList({
//     Key? key,
//     required this.page,
//   }) : super(key: key);

//   @override
//   _NoteListState createState() => _NoteListState();
// }

// class _NoteListState extends State<NoteList> {
//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: ListView.builder(
//         itemCount: widget.page.notesList.length,
//         itemBuilder: (context, index) {
//           return Padding(
//             padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 4.0),
//             child: Card(
//               child: ListTile(
//                 key: ValueKey(widget.page.notesList[index].heading),
//                 leading: const Icon(
//                   Icons.alarm,
//                 ),
//                 title: Text(
//                   'Node ${widget.page.notesList[index].heading}',
//                   style: TextStyle(
//                       color: widget.page.notesList[index].isFavorite
//                           ? Colors.green
//                           : Colors.black),
//                 ),
//                 subtitle: Text(widget.page.notesList[index].data),
//                 isThreeLine: widget.page.notesList[index].data.length > 30
//                     ? true
//                     : false,
//                 trailing: Checkbox(
//                   key: UniqueKey(),
//                   checkColor: Colors.white,
//                   value: widget.page.notesList[index].isChecked,
//                   onChanged: (value) {
//                     setState(() {
//                       widget.page.notesList[index].isChecked = value!;
//                     });
//                     if (value == true) {
//                       _selcetedNotes.add(widget.page.notesList[index]);
//                     } else {
//                         _selcetedNotes.remove(widget.page.notesList[index]);
//                     }
//                   },
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
