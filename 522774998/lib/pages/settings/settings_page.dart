import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share/share.dart';

import '../../theme/theme_cubit.dart';
import 'animations_settings.dart';
import 'settings_page_cubit.dart';

final List<String> galleryItems = [
  'images/start.jpg',
  'images/black.jpg',
  'images/light.jpg',
  'images/blue.jpg',
  'images/planets.jpg',
];

class SettingsPage extends StatelessWidget {
  static const routeName = '/Settings';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(right: 40),
          child: Text(
            'Settings',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<SettingPageCubit, SettingsPageState>(
        builder: (context, state) => _body(context),
      ),
    );
  }

  Widget _body(BuildContext context) {
    Widget _setting(IconData icon, String title, String subtitle,
        {Function onTap, Widget switching}) {
      return ListTile(
        leading: Icon(
          icon,
          size: 30,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: BlocProvider.of<SettingPageCubit>(context).state.fontSize,
            fontWeight: FontWeight.w400,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize:
                BlocProvider.of<SettingPageCubit>(context).state.fontSize - 2,
          ),
        ),
        onTap: onTap,
        trailing: Container(
          width: 60,
          child: switching,
        ),
      );
    }

    var dateSwitch = Switch(
      value: BlocProvider.of<SettingPageCubit>(context)
              .state
              .isDateModificationSwitched ??
          false,
      onChanged:
          BlocProvider.of<SettingPageCubit>(context).changeDateModification,
    );

    var bubbleSwitch = Switch(
      value: BlocProvider.of<SettingPageCubit>(context)
              .state
              .isBubbleAlignmentSwitched ??
          false,
      onChanged:
          BlocProvider.of<SettingPageCubit>(context).changeBubbleAlignment,
    );

    var dateBubbleSwitch = Switch(
      value: BlocProvider.of<SettingPageCubit>(context)
              .state
              .isDateAlignmentSwitched ??
          false,
      onChanged: BlocProvider.of<SettingPageCubit>(context).changeDateAlignment,
    );

    void showGallery(BuildContext context) {
      showDialog(
        context: context,
        builder: (_) => AnimatedGallery(),
      );
    }

    void fontSize(BuildContext context) async {
      showDialog(
        context: context,
        builder: (_) => AnimatedDialog(),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _setting(
              Icons.invert_colors,
              'Theme',
              'Light / Dark',
              onTap: BlocProvider.of<ThemeCubit>(context).changeTheme,
            ),
            _setting(
              Icons.calendar_today_outlined,
              'Date-Time Modification',
              'Allows manual date & time for an entry',
              onTap: () {
                dateSwitch.onChanged(dateSwitch.value);
              },
              switching: dateSwitch,
            ),
            _setting(
              Icons.format_align_left,
              'Bubble Alignment',
              'Force right-to-left bubble alignment',
              switching: bubbleSwitch,
              onTap: () {
                bubbleSwitch.onChanged(!bubbleSwitch.value);
              },
            ),
            _setting(
              Icons.wb_iridescent,
              'Center Date Bubble',
              'Force right-to-left date bubble alignment',
              switching: dateBubbleSwitch,
              onTap: () {
                dateBubbleSwitch.onChanged(!dateBubbleSwitch.value);
              },
            ),
            _setting(
              Icons.text_fields,
              'Font Size',
              'Small/Medium/Large',
              onTap: () {
                fontSize(context);
              },
            ),
            _setting(
              Icons.settings_backup_restore,
              'Reset all settings',
              'Reset all Visual Customizations',
              onTap: () {
                BlocProvider.of<SettingPageCubit>(context).reset();
                if (!BlocProvider.of<ThemeCubit>(context).state.isLightTheme) {
                  BlocProvider.of<ThemeCubit>(context).changeTheme();
                }
              },
            ),
            _setting(
              Icons.share,
              'Share app',
              'Share a link of the Chat Journal',
              onTap: () {
                Share.share(
                    'Join us right now and download Chat journal! \n\r https://t.me/chat_journal');
              },
            ),
            _setting(
              Icons.add_a_photo_outlined,
              'Add chat background',
              'Add picture to the background',
              onTap: () {
                showGallery(context);
                print('show');
              },
            ),
          ],
        ),
      ),
    );
  }
}
