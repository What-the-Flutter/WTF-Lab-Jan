import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'general_settings.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        centerTitle: true,
        elevation: 0.0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'Merriweather',
            fontSize: 28.0,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Theme.of(context).primaryColor,
              child: ListView(
                children: [
                  ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const GeneralSettings()),
                      );
                    },
                    leading: const Icon(
                      Icons.workspaces_filled,
                      color: Colors.redAccent,
                      size: 30.0,
                    ),
                    title: Text(
                      'General',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(fontSize: 18.0),
                    ),
                    subtitle: const Text(
                      'Themes & Interface settings',
                      style: TextStyle(
                        fontFamily: 'Dancing',
                        fontSize: 25.0,
                        color: Colors.blueGrey,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.blueGrey,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
