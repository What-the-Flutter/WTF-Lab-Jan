import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../default/default_categories.dart';
import '../main/tabs/home/cubit/categories_cubit.dart';
import 'cubit/settings_cubit.dart';

class GeneralSettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('General Settings'),
      ),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          return ListView(
            children: [
              SwitchListTile(
                title: Text('Dark mode'),
                subtitle: Text('Enables and disables dark theme mode'),
                onChanged: (value) {
                  context.read<SettingsCubit>().switchThemeMode();
                },
                value: state.themeMode == ThemeMode.dark,
              ),
              SwitchListTile(
                title: Text('Center date bubble'),
                subtitle: Text('Date bubble will be placed to center'),
                value: state.centerDateBubble,
                onChanged: (value) {
                  context.read<SettingsCubit>().switchCenterDateBubble();
                },
              ),
              ListTile(
                title: Text('Bubble alignment'),
                subtitle: Text('Right or left alignment of bubbles'),
                trailing: Icon(
                  state.bubbleAlignment == Alignment.centerRight
                      ? Icons.format_align_right
                      : Icons.format_align_left,
                ),
                onTap: () {
                  context.read<SettingsCubit>().switchBubbleAlignment();
                },
              ),
              SwitchListTile(
                title: Text('Show create record date time picker'),
                subtitle: Text(
                    "When you'll create record, you can choose date and time of this event"),
                value: state.showCreateRecordDateTimePickerButton,
                onChanged: (value) {
                  context
                      .read<SettingsCubit>()
                      .switchShowCreateRecordDateTimePicker();
                },
              ),
              ListTile(
                title: Text('Unpin all the categories'),
                subtitle: Text('All categories will be unpinned'),
                trailing: Icon(Icons.pin_drop_sharp),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (newContext) {
                      return AlertDialog(
                        title: Text('All categories will be unpinned'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              context.read<CategoriesCubit>().unpinAll();
                              Navigator.of(context).pop();
                            },
                            child: Text('Ok'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              ListTile(
                title: Text('Font size'),
                subtitle: Text('Choose app font size'),
                trailing: Icon(Icons.text_format),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (newContext) {
                      return SimpleDialog(
                        title: Text('Font size'),
                        children: [
                          SimpleDialogOption(
                            child: Text('Small'),
                            onPressed: () {
                              context
                                  .read<SettingsCubit>()
                                  .setTextTheme('small');
                              Navigator.of(context).pop();
                            },
                          ),
                          SimpleDialogOption(
                            child: Text('Normal'),
                            onPressed: () {
                              context
                                  .read<SettingsCubit>()
                                  .setTextTheme('default');
                              Navigator.of(context).pop();
                            },
                          ),
                          SimpleDialogOption(
                            child: Text('Large'),
                            onPressed: () {
                              context
                                  .read<SettingsCubit>()
                                  .setTextTheme('large');
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              ListTile(
                title: Text('Categories reset'),
                subtitle: Text(
                  'All the custom categories will be deleted. '
                  'Initial categories will be cleared',
                ),
                trailing: Icon(Icons.delete),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (newContext) {
                      return AlertDialog(
                        title: Text('Are you sure?'),
                        content: Text('All categories will be deleted'),
                        actions: [
                          TextButton(
                            child: Text('No'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: Text('Yes'),
                            onPressed: () async {
                              await context.read<CategoriesCubit>().deleteAll();
                              context
                                  .read<CategoriesCubit>()
                                  .addAll(categories: defaultCategories);
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              ListTile(
                title: Text('App initial reset'),
                subtitle: Text('All the app settings will be resetted'),
                trailing: Icon(Icons.restore),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (newContext) {
                      return AlertDialog(
                        title: Text('Are you sure?'),
                        content: Text('All data will be erased'),
                        actions: [
                          TextButton(
                            child: Text('No'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: Text('Yes'),
                            onPressed: () async {
                              await context.read<CategoriesCubit>().deleteAll();
                              context
                                  .read<CategoriesCubit>()
                                  .addAll(categories: defaultCategories);
                              context.read<SettingsCubit>().reset();
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
