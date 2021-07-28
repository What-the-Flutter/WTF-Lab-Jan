// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter',
      home: Scaffold(
        body: ListView.separated(
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'запись $index',
                textScaleFactor: 2,
              ),
            );
          },
          separatorBuilder: (_, __) => Container(
            height: 1,
            color: Colors.black,
          ),
          itemCount: 20,
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.business),
              label: 'Business',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.car_rental),
              label: 'Race',
            ),
          ],
          currentIndex: 0,
          selectedItemColor: Colors.amber[800],
          onTap: (_) {},
        ),
        appBar: AppBar(
          backgroundColor: Colors.green,
          centerTitle: true,
          title: const Text('Flutter'),
          leading: IconButton(
            icon: Icon(Icons.wb_sunny),
            onPressed: () {},
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {},
          label: const Text('bolt'),
          icon: const Icon(Icons.bolt),
          backgroundColor: Colors.green,
        ),
      ),
    );
  }
}
