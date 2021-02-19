import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreateNewPage extends StatefulWidget {
  static const routName = 'createPage';
  @override
  _CreateNewPageState createState() => _CreateNewPageState();
}

class _CreateNewPageState extends State<CreateNewPage> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Text('Create a new Page'),
          ),
          Expanded(
            child: TextField(
              controller: _controller,
            ),
          ),
          Expanded(
            child: Container(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 10.0,
        child: Icon(
          Icons.close,
          color: Colors.black,
        ),
        onPressed: () {},
      ),
    );
  }
}
