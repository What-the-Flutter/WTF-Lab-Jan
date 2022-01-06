import 'package:flutter/material.dart';
import '../entity/entities.dart' as entity;
import '../main.dart';
import 'chat_message.dart';
import 'datetime_picker.dart';

class ChatPage extends StatefulWidget {
  final entity.Topic topic;
  final BuildContext context;

  ChatPage(this.topic, this.context);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _descriptionController = TextEditingController();
  final _scrollController = ScrollController();
  late List<entity.Message> _elements;
  final List<entity.Message> _selected = List.empty(growable: true);

  bool _editingFlag = false;
  int _editingIndex = 0;

  bool _selectionFlag = false;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  IconData _addedIcon = Icons.feed_rounded;
  int _addedType = 0;

  void _changeAddedType() {
    _addedType = (_addedType + 1) % 3;
    _addedIcon = _addedType == 0
        ? Icons.feed_rounded
        : (_addedType == 1 ? Icons.event_rounded : Icons.drive_file_rename_outline);
  }

  void changeAddedTypeTo(int i) {
    if (_addedType != i) {
      _addedType = i;
      _addedIcon = _addedType == 0
          ? Icons.feed_rounded
          : (_addedType == 1 ? Icons.event_rounded : Icons.drive_file_rename_outline);
    }
  }

  DateTime? _getDateTime() {
    if (_selectedDate != null && _selectedTime != null) {
      return DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );
    } else if (_selectedDate != null) {
      return DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
      );
    }
    return null;
  }

  void _onScrollEvent() {
    final pixels = _scrollController.position.pixels;
    if (pixels == _scrollController.position.maxScrollExtent) {
      setState(() => widget.topic.loadElements());
    }
  }

  void _onEditingCalled(entity.Message o, int index) {
    _editingIndex = index;
    _editingFlag = true;
    changeAddedTypeTo(entity.getTypeId(o));
    switch (o.runtimeType) {
      case entity.Task:
        _descriptionController.text = (o as entity.Task).description;
        break;
      case entity.Event:
        _selectedDate = (o as entity.Event).scheduledTime;
        if (_selectedDate != null) {
          _selectedTime = TimeOfDay.fromDateTime(_selectedDate!);
        }
        _descriptionController.text = o.description;
        break;
      case entity.Note:
        _descriptionController.text = (o as entity.Note).description;
        break;
    }
  }

  @override
  void initState() {
    _scrollController.addListener(_onScrollEvent);
    _elements = widget.topic.getElements();
    super.initState();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final decorator = ThemeDecorator.of(widget.context)!;
    return Scaffold(
      backgroundColor: decorator.theme.backgroundColor,
      appBar: _chatAppBar(decorator),
      body: Column(
        children: <Widget>[
          if (_selectionFlag)
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
                          for (var item in _selected) {
                            entity.MessageLoader.remove(item);
                          }
                          _selected.clear();
                          _selectionFlag = false;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      child: const Text('Cancel'),
                      onPressed: () => setState(() {
                        _selected.clear();
                        _selectionFlag = false;
                      }),
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              reverse: true,
              itemCount: _elements.length,
              shrinkWrap: true,
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              physics: const AlwaysScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return ChatMessage(
                  item: _elements[index],
                  onDeleted: () => setState(() => entity.MessageLoader.remove(_elements[index])),
                  onEdited: () => setState(() => _onEditingCalled(_elements[index], index)),
                  onSelection: () => setState(() => _selectionFlag = true),
                  onSelected: () {
                    if (_selected.contains(_elements[index])) {
                      _selected.remove(_elements[index]);
                    } else {
                      _selected.add(_elements[index]);
                    }
                  },
                  selection: _selectionFlag,
                  decorator: decorator,
                );
              },
            ),
          ),
          _inputForm(),
        ],
      ),
    );
  }

  PreferredSizeWidget _chatAppBar(ThemeDecorator decorator) {
    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: decorator.theme.themeColor2,
      flexibleSpace: SafeArea(
        child: Row(
          children: <Widget>[
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.arrow_back,
                color: decorator.theme.iconColor2,
              ),
            ),
            const SizedBox(
              width: 2,
            ),
            CircleAvatar(
              backgroundColor: decorator.theme.avatarColor1,
              child: Icon(
                widget.topic.icon,
                color: Colors.white,
                size: 25,
              ),
              radius: 20,
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
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: decorator.theme.textColor2,
                    ),
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
            IconButton(
              icon: const Icon(Icons.brightness_4_rounded),
              color: decorator.theme.iconColor2,
              tooltip: 'Change theme',
              onPressed: () => setState(decorator.theme.changeTheme),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputForm() {
    switch (_addedType) {
      case (0):
        return _defaultInputForm(true);
      case (1):
        return _eventInputForm();
      default:
        return _defaultInputForm(false);
    }
  }

  Widget _eventInputForm() {
    final decorator = ThemeDecorator.of(widget.context)!;
    return Container(
      padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
      width: double.infinity,
      color: decorator.theme.themeColor2,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Container(
            height: 40,
            child: FloatingActionButton(
              backgroundColor: decorator.theme.buttonColor,
              onPressed: () => setState(_changeAddedType),
              child: Container(
                height: 30,
                width: 30,
                child: Icon(
                  _addedIcon,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(
            child: Form(
              child: Column(
                children: [
                  DateTimePicker(
                    selectTime: (value) => setState(() {
                      _selectedTime = value;
                      _selectedDate ??= DateTime.now();
                    }),
                    selectDate: (value) => setState(() => _selectedDate = value),
                    selectedDate: _selectedDate,
                    labelText: 'Scheduled date',
                    selectedTime: _selectedTime,
                    decorator: decorator,
                  ),
                  Container(
                    height: 40,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Write event description...',
                        hintStyle: TextStyle(color: Colors.grey.shade600),
                        border: InputBorder.none,
                      ),
                      controller: _descriptionController,
                      style: TextStyle(color: decorator.theme.textColor2),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Container(
            height: 40,
            child: FloatingActionButton(
              backgroundColor: decorator.theme.buttonColor,
              onPressed: () => setState(() {
                FocusScope.of(context).requestFocus(FocusNode());
                if (!_editingFlag && _descriptionController.text.isNotEmpty) {
                  entity.MessageLoader.add(entity.Event(
                    scheduledTime: _getDateTime(),
                    description: _descriptionController.text.toString(),
                    topic: widget.topic,
                  ));
                  _selectedTime = null;
                  _selectedDate = null;
                } else if (_descriptionController.text.isNotEmpty) {
                  _editingFlag = false;
                  (_elements[_editingIndex] as entity.Event).description = _descriptionController.text;
                  (_elements[_editingIndex] as entity.Event).scheduledTime = _getDateTime();
                  _selectedTime = null;
                  _selectedDate = null;
                }
                _descriptionController.clear();
              }),
              child: const Icon(
                Icons.send,
                color: Colors.white,
                size: 18,
              ),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _defaultInputForm(bool isTask) {
    final decorator = ThemeDecorator.of(widget.context)!;
    return Container(
      padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
      height: 60,
      width: double.infinity,
      color: decorator.theme.themeColor2,
      child: Row(
        children: <Widget>[
          FloatingActionButton(
            backgroundColor: decorator.theme.buttonColor,
            onPressed: () => setState(_changeAddedType),
            child: Container(
              height: 30,
              width: 30,
              child: Icon(
                _addedIcon,
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
              decoration: InputDecoration(
                hintText: isTask ? 'Write task...' : 'Write note...',
                hintStyle: TextStyle(color: Colors.grey.shade600),
                border: InputBorder.none,
              ),
              controller: _descriptionController,
              style: TextStyle(color: decorator.theme.textColor2),
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          FloatingActionButton(
            backgroundColor: decorator.theme.buttonColor,
            onPressed: () => setState(() {
              FocusScope.of(context).requestFocus(FocusNode());
              if (!_editingFlag && _descriptionController.text.isNotEmpty) {
                if (isTask) {
                  entity.MessageLoader.add(entity.Task(
                    description: _descriptionController.text.toString(),
                    topic: widget.topic,
                  ));
                } else {
                  entity.MessageLoader.add(entity.Note(
                    description: _descriptionController.text.toString(),
                    topic: widget.topic,
                  ));
                }
              } else if (_descriptionController.text.isNotEmpty) {
                _editingFlag = false;
                if (isTask) {
                  (_elements[_editingIndex] as entity.Task).description = _descriptionController.text;
                } else {
                  (_elements[_editingIndex] as entity.Note).description = _descriptionController.text;
                }
              }
              _descriptionController.clear();
            }),
            child: const Icon(
              Icons.send,
              color: Colors.white,
              size: 18,
            ),
            elevation: 0,
          ),
        ],
      ),
    );
  }
}
