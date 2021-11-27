import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../data/list_of_notes.dart';
import '../../note.dart';

int _nodeCount = 0;

class DailyPage extends StatefulWidget {
  const DailyPage({Key? key}) : super(key: key);

  @override
  _DailyPageState createState() => _DailyPageState();
}

class _DailyPageState extends State<DailyPage> {
  String _nodeInput = '';

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    void editItem(String item, String action) {
      switch (action) {
        case 'edit':
          {
            print('edit');
            for (var n in listOfNotes) {
              if (n.heading == item) {
                _controller.text = n.data;
                listOfNotes.remove(n);
                break;
              }
            }
            break;
          }
        case 'del':
          {
            for (var n in listOfNotes) {
              if (n.heading == item) {
                setState(() {
                  listOfNotes.remove(n);
                });
                break;
              }
            }
            break;
          }
        case 'fav':
          {
            for (var n in listOfNotes) {
              if (n.heading == item) {
                setState(() {
                  n.isFavorite == false
                      ? n.isFavorite = true
                      : n.isFavorite = false;
                });
                break;
              }
            }
            break;
          }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily'),
        actions: const <Widget>[
          IconButton(
            icon: Icon(
              Icons.star,
              color: Colors.yellow,
            ),
            onPressed: null,
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: listOfNotes.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 1.0, horizontal: 4.0),
                  child: Card(
                      child: ListTile(
                    key: ValueKey(listOfNotes[index].heading),
                    leading: const Icon(
                      Icons.alarm,
                    ),
                    title: Text(
                      'Node ${listOfNotes[index].heading}',
                      style: TextStyle(
                          color: listOfNotes[index].isFavorite
                              ? Colors.green
                              : Colors.black),
                    ),
                    subtitle: Text(listOfNotes[index].data),
                    isThreeLine: true,
                    onLongPress: () {
                      Clipboard.setData(
                          ClipboardData(text: listOfNotes[index].data));
                    },
                    trailing: DropdownButton<String>(
                      icon: const Icon(Icons.edit),
                      iconSize: 24,
                      elevation: 16,
                      style: const TextStyle(color: Colors.deepPurple),
                      onChanged: (newValue) {
                        editItem(listOfNotes[index].heading, newValue!);
                      },
                      items: <String>['edit', 'del', 'fav']
                          .map<DropdownMenuItem<String>>((value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  )),
                );
              },
            ),
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: IconButton(
                  icon: const Icon(
                    Icons.image,
                    color: Colors.blue,
                  ),
                  onPressed: () {
                    setState(() {});
                  },
                ),
              ),
              Expanded(
                flex: 6,
                child: Container(
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
              ),
              Expanded(
                flex: 1,
                child: IconButton(
                  icon: const Icon(
                    Icons.send,
                    color: Colors.blue,
                  ),
                  onPressed: () {
                    setState(() {
                      _nodeCount++;
                      _nodeInput = _controller.text;
                      listOfNotes.add(
                        ListObject(
                          heading: _nodeCount.toString(),
                          data: _nodeInput,
                          avatarUrl: '1.png',
                          ptiority: 'medium',
                        ),
                      );
                      _controller.text = '';
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
