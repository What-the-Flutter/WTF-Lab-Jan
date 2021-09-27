import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/cubit/settings/settings_cubit.dart';
import 'package:notes/cubit/settings/settings_state.dart';
import 'package:notes/cubit/themes/theme_cubit.dart';

const double iconSize = 25.0;

class GeneralSettings extends StatefulWidget {
  @override
  _GeneralSettingsState createState() => _GeneralSettingsState();
}

class _GeneralSettingsState extends State<GeneralSettings> {
  @override
  void initState() {
    BlocProvider.of<SettingsCubit>(context).init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, GeneralSettingsStates>(
      builder: (context, state) {
        return Scaffold(
          appBar: _appBar,
          body: _listView(state),
        );
      },
    );
  }

  AppBar get _appBar {
    return AppBar(
      title: const Text(
        'General',
      ),
    );
  }

  Widget _listView(GeneralSettingsStates state) {
    return ListView(
      padding: const EdgeInsets.only(left: 10, right: 10),
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(6),
          child: Text(
            'Visuals',
            style: TextStyle(
              fontSize: state.textSize.toDouble() - 2,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        GestureDetector(
          child: ListTile(
            leading: BlocProvider.of<ThemeCubit>(context).state.isDarkMode!
                ? const Icon(Icons.dark_mode, size: iconSize)
                : const Icon(Icons.light_mode, size: iconSize),
            title: Text(
              'Theme',
              style: TextStyle(
                fontSize: state.textSize.toDouble(),
              ),
            ),
            subtitle: Text(
              'Light/Dark',
              style: TextStyle(
                fontSize: state.textSize.toDouble() - 3,
              ),
            ),
          ),
          onTap: () => BlocProvider.of<ThemeCubit>(context).changeTheme(),
        ),
        GestureDetector(
          child: ListTile(
            leading: const Icon(Icons.star_border_purple500, size: iconSize),
            title: Text(
              'AccentColor',
              style: TextStyle(
                fontSize: state.textSize.toDouble(),
              ),
            ),
            subtitle: Text(
              'Purple, Cyan and more',
              style: TextStyle(
                fontSize: state.textSize.toDouble() - 3,
              ),
            ),
          ),
          onTap: () {
            //TODO
          },
        ),
        GestureDetector(
          child: ListTile(
            leading: const Icon(Icons.font_download, size: iconSize),
            title: Text(
              'Typeface',
              style: TextStyle(
                fontSize: state.textSize.toDouble(),
              ),
            ),
            subtitle: Text(
              'OpenSans/RobotoMono',
              style: TextStyle(
                fontSize: state.textSize.toDouble() - 3,
              ),
            ),
          ),
          onTap: () {
            //TODO
          },
        ),
        GestureDetector(
          child: ListTile(
            leading: const Icon(Icons.format_size, size: iconSize),
            title: Text(
              'Font Size',
              style: TextStyle(
                fontSize: state.textSize.toDouble(),
              ),
            ),
            subtitle: Text(
              'Small/Default/Large',
              style: TextStyle(
                fontSize: state.textSize.toDouble() - 3,
              ),
            ),
          ),
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context, 'Ok');
                      },
                      child: Text(
                        'Ok',
                        style: TextStyle(
                          fontSize: state.textSize.toDouble() + 3,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                  ],
                  title: Text(
                    'Font Size',
                    style: TextStyle(
                      fontSize: state.textSize.toDouble() + 5,
                    ),
                  ),
                  content: ListView(
                    shrinkWrap: true,
                    children: [
                      ListTile(
                        title: Text(
                          'Small',
                          style: TextStyle(
                            fontSize: state.textSize.toDouble(),
                          ),
                        ),
                        onTap: () {
                          BlocProvider.of<SettingsCubit>(context)
                              .changeTextSize(12);
                          Navigator.pop(context, 'Ok');
                        },
                      ),
                      ListTile(
                        title: Text(
                          'Default',
                          style: TextStyle(
                            fontSize: state.textSize.toDouble(),
                          ),
                        ),
                        onTap: () {
                          BlocProvider.of<SettingsCubit>(context)
                              .changeTextSize(16);
                          Navigator.pop(context, 'Ok');
                        },
                      ),
                      ListTile(
                        title: Text(
                          'Large',
                          style: TextStyle(
                            fontSize: state.textSize.toDouble(),
                          ),
                        ),
                        onTap: () {
                          BlocProvider.of<SettingsCubit>(context)
                              .changeTextSize(20);
                          Navigator.pop(context, 'Ok');
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
        GestureDetector(
          child: ListTile(
            leading: const Icon(Icons.settings_backup_restore, size: iconSize),
            title: Text(
              'Reset All Preferences',
              style: TextStyle(
                fontSize: state.textSize.toDouble(),
              ),
            ),
            subtitle: Text(
              'Reset all Visual Customizations',
              style: TextStyle(
                fontSize: state.textSize.toDouble() - 3,
              ),
            ),
          ),
          onTap: () {
            BlocProvider.of<SettingsCubit>(context).resetAllPreferences();
          },
        ),
        Container(
          padding: const EdgeInsets.all(6),
          child: Text(
            'Chat Interface',
            style: TextStyle(
                fontSize: state.textSize.toDouble() - 2,
                fontWeight: FontWeight.bold),
          ),
        ),
        GestureDetector(
          child: ListTile(
            leading: const Icon(Icons.date_range, size: iconSize),
            title: Text(
              'Date-Time Modification',
              style: TextStyle(
                fontSize: state.textSize.toDouble(),
              ),
            ),
            subtitle: Text(
              'Allow manual date & time for an entry',
              style: TextStyle(
                fontSize: state.textSize.toDouble() - 3,
              ),
            ),
            trailing: Switch(
              onChanged: (value) {
                BlocProvider.of<SettingsCubit>(context)
                    .changeDateTimeModification();
              },
              value: state.isDateTimeModification,
            ),
          ),
          onTap: () => BlocProvider.of<SettingsCubit>(context)
              .changeDateTimeModification(),
        ),
        GestureDetector(
          child: ListTile(
            leading: state.isBubbleAlignment
                ? const Icon(Icons.format_align_left_outlined, size: iconSize)
                : const Icon(Icons.format_align_right_outlined, size: iconSize),
            title: Text(
              'Bubble Alignment',
              style: TextStyle(
                fontSize: state.textSize.toDouble(),
              ),
            ),
            subtitle: Text(
              'Force right-to-left bubble alignment',
              style: TextStyle(
                fontSize: state.textSize.toDouble() - 3,
              ),
            ),
            trailing: Switch(
              onChanged: (value) {
                BlocProvider.of<SettingsCubit>(context).changeBubbleAlignment();
              },
              value: state.isBubbleAlignment,
            ),
          ),
          onTap: () =>
              BlocProvider.of<SettingsCubit>(context).changeBubbleAlignment(),
        ),
        GestureDetector(
          child: ListTile(
            leading: state.isCenterDateBubble
                ? const Icon(Icons.filter_center_focus_outlined, size: iconSize)
                : const Icon(Icons.center_focus_strong_outlined,
                    size: iconSize),
            title: Text(
              'Center Date Bubble',
              style: TextStyle(
                fontSize: state.textSize.toDouble(),
              ),
            ),
            trailing: Switch(
              onChanged: (value) {
                BlocProvider.of<SettingsCubit>(context)
                    .changeCenterDateBubble();
              },
              value: state.isCenterDateBubble,
            ),
          ),
          onTap: () =>
              BlocProvider.of<SettingsCubit>(context).changeCenterDateBubble(),
        ),
        GestureDetector(
          child: ListTile(
            leading: const Icon(
              Icons.image,
              size: iconSize,
            ),
            title: Text(
              'Change background message',
              style: TextStyle(
                fontSize: state.textSize.toDouble(),
              ),
            ),
            subtitle: Text(
              'Chat background image',
              style: TextStyle(
                fontSize: state.textSize.toDouble() - 3,
              ),
            ),
          ),
          onTap: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: ListView(
                      shrinkWrap: true,
                      children: [
                        state.imagePath != null && state.imagePath != ''
                            ? Align(
                                alignment: Alignment.center,
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width / 1.5,
                                  height:
                                      MediaQuery.of(context).size.height / 3,
                                  child: Image.file(
                                    File(
                                      state.imagePath!,
                                    ),
                                  ),
                                ),
                              )
                            : const Align(
                                alignment: Alignment.center,
                                child: Text('No uploaded image'),
                              ),
                        ListTile(
                          title: Text(
                            'Upload image',
                            style: TextStyle(
                              fontSize: state.textSize.toDouble(),
                            ),
                          ),
                          leading: const Icon(Icons.add_box_rounded),
                          onTap: () async {
                            BlocProvider.of<SettingsCubit>(context)
                                .addImageFromGallery();
                            Navigator.pop(context, 'Ok');
                          },
                        ),
                        ListTile(
                          title: Text(
                            'Delete image',
                            style: TextStyle(
                              fontSize: state.textSize.toDouble(),
                            ),
                          ),
                          leading: const Icon(Icons.delete),
                          onTap: () {
                            BlocProvider.of<SettingsCubit>(context)
                                .changeImagePath('');
                            Navigator.pop(context, 'Ok');
                          },
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, 'Ok');
                        },
                        child: Text(
                          'Ok',
                          style: TextStyle(
                            fontSize: state.textSize.toDouble() + 3,
                          ),
                        ),
                      ),
                    ],
                  );
                });
          },
        ),
      ],
    );
  }
}
