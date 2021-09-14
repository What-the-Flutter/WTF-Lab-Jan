import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../constants.dart';

class AddScreen extends StatelessWidget {
  final _controller = TextEditingController();
  final _icons = [
    Icons.fiber_smart_record_outlined,
    Icons.monetization_on_outlined,
    Icons.airplanemode_on_sharp,
    Icons.card_travel,
    Icons.directions_car,
    Icons.home_outlined,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: ListView(
        children: [
          Stack(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(
                    Icons.clear,
                    size: 30,
                    color: Theme.of(context).accentColor,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 5.0),
                height: 220,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(300),
                    topRight: Radius.circular(300),
                  ),
                ),
              ),
              Column(
                children: [
                  Center(
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 10.0),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50.0, vertical: 30.0),
                      decoration: const BoxDecoration(
                        color: white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(300),
                          bottomLeft: Radius.circular(200),
                          bottomRight: Radius.circular(50),
                        ),
                      ),
                      child: const Text(
                        'Create a new page',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 24.0, color: black),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 30),
                    padding: const EdgeInsets.only(
                        left: 10.0, top: 4.0, right: 10.0),
                    decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: TextField(
                      maxLines: 1,
                      controller: _controller,
                      enableSuggestions: true,
                      autofocus: true,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                        hintText: 'Enter page name...',
                        hintStyle: TextStyle(color: black),
                        border: InputBorder.none,
                      ),
                      cursorColor: white,
                      style: const TextStyle(color: Colors.black87),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 30.0,
          ),
          Container(
            height: 300,
            child: GridView.builder(
              padding: const EdgeInsets.all(20.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: _icons.length,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).accentColor,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  width: 50,
                  child: Icon(
                    _icons[index],
                    size: 50.0,
                    color: black,
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).accentColor,
        child: const Icon(
          Icons.done,
          size: 50,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
