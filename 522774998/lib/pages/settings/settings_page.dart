import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:share/share.dart';
import '../../theme/theme_cubit.dart';

import 'settings_page_cubit.dart';

final List<String> galleryItems = [
  'images/start.jpg',
  'images/black.jpg',
  'images/light.jpg',
  'images/blue.jpg',
  'images/planets.jpg',
];

class SettingsPage extends StatelessWidget {
  static const routeName = '/SettingsPage';

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

    var currentIndex = 0;

    void onPageChanged(int index) {
      currentIndex = index;
    }

    void showGallery(BuildContext context) {
      showDialog(
        context: context,
        builder: (galleryContext) => Scaffold(
          body: Stack(
            children: [
              PhotoViewGallery.builder(
                itemCount: galleryItems.length,
                scrollPhysics: const BouncingScrollPhysics(),
                builder: (context, index) {
                  return PhotoViewGalleryPageOptions(
                    imageProvider: AssetImage(
                      galleryItems[index],
                    ),
                  );
                },
                loadingBuilder: (context, event) => Center(
                  child: Container(
                    width: 20.0,
                    height: 20.0,
                    child: CircularProgressIndicator(
                      value: event == null
                          ? 0
                          : event.cumulativeBytesLoaded /
                              event.expectedTotalBytes,
                    ),
                  ),
                ),
                onPageChanged: onPageChanged,
              ),
              Container(
                padding: EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CircleAvatar(
                      backgroundColor: BlocProvider.of<ThemeCubit>(context)
                          .state
                          .theme
                          .accentColor,
                      child: IconButton(
                        icon: Icon(
                          Icons.close,
                          color: Colors.black,
                        ),
                        onPressed: () => Navigator.pop(galleryContext),
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: BlocProvider.of<ThemeCubit>(context)
                          .state
                          .theme
                          .accentColor,
                      child: IconButton(
                        icon: Icon(
                          Icons.done,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          print(currentIndex);
                          BlocProvider.of<SettingPageCubit>(context)
                              .changeIndexBackground(currentIndex);
                          Navigator.pop(galleryContext);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    void fontSize(BuildContext context) async {
      showDialog(
        context: context,
        builder: (alertContext) => AlertDialog(
          content: StatefulBuilder(
            builder: (context, setState) => Container(
              height: 150,
              width: 100,
              child: ListView(
                children: <Widget>[
                  TextButton(
                    child: Text(
                      'Small',
                      style: TextStyle(color: Colors.black),
                    ),
                    onPressed: () {
                      BlocProvider.of<SettingPageCubit>(context)
                          .changeFontSize(14);
                      Navigator.of(alertContext).pop();
                    },
                  ),
                  TextButton(
                    child: Text(
                      'Medium',
                      style: TextStyle(color: Colors.black),
                    ),
                    onPressed: () {
                      BlocProvider.of<SettingPageCubit>(context)
                          .changeFontSize(16);
                      Navigator.of(alertContext).pop();
                    },
                  ),
                  TextButton(
                    child: Text(
                      'Large',
                      style: TextStyle(color: Colors.black),
                    ),
                    onPressed: () {
                      BlocProvider.of<SettingPageCubit>(context)
                          .changeFontSize(18);
                      Navigator.of(alertContext).pop();
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Ok',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                Navigator.of(alertContext).pop();
              },
            ),
          ],
        ),
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
