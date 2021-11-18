import 'package:chat_journal/theme/theme_constants.dart';
import 'package:chat_journal/theme/theme_cubit.dart';
import 'package:chat_journal/theme/theme_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GeneralSettings extends StatefulWidget {
  const GeneralSettings({Key? key}) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<GeneralSettings> {
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
          'General',
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
              child: Column(
                children: [
                  BlocBuilder<ThemeCubit, ThemeState>(
                    builder: (context, state) {
                      return ListTile(
                        onTap: () {
                          BlocProvider.of<ThemeCubit>(context).changeTheme();
                        },
                        leading: state.isLight
                            ? const Icon(
                                Icons.wb_incandescent,
                                color: themeIconLight,
                                size: 30,
                              )
                            : const Icon(
                                Icons.wb_incandescent_outlined,
                                color: themeIconDark,
                                size: 30,
                              ),
                        title: Text(
                          'Theme',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(fontSize: 18.0),
                        ),
                        subtitle: const Text(
                          'Light / Dark ',
                          style: TextStyle(
                            fontFamily: 'Dancing',
                            fontSize: 25.0,
                            color: Colors.blueGrey,
                          ),
                        ),
                      );
                    },
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
