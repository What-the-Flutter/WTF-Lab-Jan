import 'package:flutter/material.dart';
import '../entity/entities.dart' as entity;
import 'chat_message.dart';

class ChatPage extends StatefulWidget {
  final entity.Topic topic;

  ChatPage(this.topic);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _categoryController = TextEditingController();
  late List<entity.Message> elements;
  final List<entity.Message> selected = List.empty(growable: true);
  bool editingFlag = false;
  bool selectionFlag = false;
  int editingIndex = 0;

  @override
  void initState() {
    elements = widget.topic.getElements();
    super.initState();
  }

  @override
  void dispose() {
    _categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        flexibleSpace: SafeArea(
          child: Container(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  width: 2,
                ),
                CircleAvatar(
                  backgroundImage: widget.topic.getImageProvider(),
                  maxRadius: 20,
                ),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        widget.topic.name,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Text(
                        'Online',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.settings,
                  color: Colors.black54,
                ),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Column(
            children: [
              if (selectionFlag)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                  ),
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Expanded(
                        child: TextButton(
                          child: const Text('Delete'),
                          onPressed: () {
                            setState(() {
                              for (var item in selected) {
                                elements.remove(item);
                              }
                              selected.clear();
                              selectionFlag = false;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: TextButton(
                          child: const Text('Cancel'),
                          onPressed: () => setState(() {
                            selected.clear();
                            selectionFlag = false;
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              ListView.builder(
                itemCount: elements.length,
                shrinkWrap: true,
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return ChatMessage(
                    item: elements[index],
                    onDeleted: () => setState(() {
                      elements.remove(elements[index]);
                    }),
                    onEdited: () => setState(() {
                      _categoryController.text =
                          (elements[index] as entity.Note).description;
                      editingIndex = index;
                      editingFlag = true;
                    }),
                    onSelection: () => setState(() => selectionFlag = true),
                    onSelected: () {
                      if (selected.contains(elements[index])) {
                        selected.remove(elements[index]);
                      } else {
                        selected.add(elements[index]);
                      }
                    },
                    selection: selectionFlag,
                  );
                },
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
              height: 60,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: 'Write message...',
                        hintStyle: TextStyle(color: Colors.black54),
                        border: InputBorder.none,
                      ),
                      controller: _categoryController,
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  FloatingActionButton(
                    onPressed: () => setState(() {
                      FocusScope.of(context).requestFocus(FocusNode());
                      if (!editingFlag) {
                        elements.add(
                          entity.Note(
                            description: _categoryController.text.toString(),
                            topic: widget.topic,
                          ),
                        );
                      } else {
                        editingFlag = false;
                        (elements[editingIndex] as entity.Note).description =
                            _categoryController.text;
                      }
                      _categoryController.clear();
                    }),
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 18,
                    ),
                    backgroundColor: Colors.blue,
                    elevation: 0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
